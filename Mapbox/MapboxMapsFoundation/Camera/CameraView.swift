import UIKit

fileprivate extension BaseMapView {
    var cameraOptions : CameraOptions {
        let options = try! self.__map.getCameraOptions(forPadding: nil)
        return options
    }
}

/// A view that represents a camera view port.
public class CameraView: UIView {

    public var camera: CameraOptions {
        get {
            let camera = CameraOptions(center: self.centerCoordinate,
                                       padding: self.padding,
                                       anchor: self.anchor,
                                       zoom: self.zoom,
                                       bearing: CLLocationDirection(self.bearing),
                                       pitch: self.pitch)
            return camera
        }

        set {
            if let zoom = newValue.zoom {
                self.zoom = zoom
            }

            if let bearing = newValue.bearing {
                self.bearing = CGFloat(bearing)
            }

            if let pitch = newValue.pitch {
                self.pitch = pitch
            }

            if let padding = newValue.padding {
                self.padding = padding
            }

            if let anchor = newValue.anchor {
                self.anchor = anchor
            }

            if let centerCoordinate = newValue.center {
                self.centerCoordinate = centerCoordinate
            }
        }

    }

    /// The camera's zoom. Animatable.
    @objc dynamic public var zoom: CGFloat {
        get {
            return CGFloat(mapView.cameraOptions.zoom!)
        }

        set {
            layer.opacity = Float(newValue)
        }
    }



    /// The camera's bearing. Animatable.
    @objc dynamic public var bearing: CGFloat {
        get {
            return CGFloat(mapView.cameraOptions.bearing!)
        }

        set {
            layer.cornerRadius = CGFloat(newValue)
        }
    }

    /// Coordinate at the center of the camera. Animatable.
    @objc dynamic public var centerCoordinate: CLLocationCoordinate2D {
        get {
            mapView.cameraOptions.center!
        }

        set {
            layer.position = CGPoint(x: newValue.longitude, y: newValue.latitude)
        }
    }


    @objc dynamic public var padding: UIEdgeInsets {
        get {
            mapView.cameraOptions.padding ?? UIEdgeInsets.zero
        }
        set {
            // TODO: figure out how to handle padding
        }
    }

    /// The camera's pitch. Animatable.
    @objc dynamic public var pitch: CGFloat {
        get {
            return mapView.cameraOptions.pitch!
        }

        set {
            layer.bounds = CGRect(x: 0, y: 0, width: newValue, height: 0)
        }
    }

    /// The screen coordinate that the map rotates, pitches and zooms around. Setting this also affects the horizontal vanishing point when pitched. Animatable.
    @objc dynamic public var anchor: CGPoint {
        get {
            return layer.presentation()?.anchorPoint ?? .zero
        }

        set {
            layer.anchorPoint = newValue
        }
    }

    private var localCenterCoordinate: CLLocationCoordinate2D {
        let proxyCoord = layer.presentation()?.position ?? layer.position
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(proxyCoord.y), longitude: CLLocationDegrees(proxyCoord.x))
    }

    private var localZoomLevel: Double {
        return Double(layer.presentation()?.opacity ?? layer.opacity)
    }

    private var localBearing: CLLocationDirection {
        return CLLocationDirection(layer.presentation()?.cornerRadius ?? layer.cornerRadius)
    }

    private var localPitch: CGFloat {
        return layer.presentation()?.bounds.width ?? layer.bounds.width
    }

    private var localAnchorPoint: CGPoint {
        return layer.presentation()?.anchorPoint ?? layer.anchorPoint
    }

    var isActive = false {
        didSet {
            setFromValuesWithMapView()
        }
    }

    private unowned var mapView: BaseMapView!
    private var displayLink: CADisplayLink!


    init(mapView: BaseMapView, edgeInsets: UIEdgeInsets = .zero) {
        self.mapView = mapView
        super.init(frame: .zero)

        self.isHidden = true
        self.isUserInteractionEnabled = false

        // Sync default values from MBXMap
        centerAnchorPointInside(edgeInsets: edgeInsets)
        setFromValuesWithMapView()

        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: RunLoop.Mode.common)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        displayLink.remove(from: .current, forMode: RunLoop.Mode.common)
        displayLink = nil
    }

    private func setFromValuesWithMapView() {
        self.zoom = CGFloat(mapView.cameraOptions.zoom ?? 0)
        self.bearing = CGFloat(mapView.cameraOptions.bearing!) ?? 0 + (isActive ? 36000.0 : 0.0)
        self.pitch = CGFloat(mapView.cameraOptions.pitch ?? 0)
        self.centerCoordinate = mapView.coordinate(for: localAnchorPoint)
    }

    func centerAnchorPointInside(edgeInsets: UIEdgeInsets) {
        let x = (self.mapView.bounds.size.width - edgeInsets.left - edgeInsets.right) / 2.0 + edgeInsets.left
        let y = (self.mapView.bounds.size.height - edgeInsets.top - edgeInsets.bottom) / 2.0 + edgeInsets.top
        anchor = CGPoint(x: x, y: y)
    }

    @objc private func update() {

        let camera = CameraOptions()
        camera.center = localCenterCoordinate
        camera.zoom = CGFloat(localZoomLevel)
        camera.bearing = localBearing
        camera.pitch = localPitch


        if let _ = self.layer.animationKeys() {
//            print("layer.presentation: \(layer.presentation()), layer.animationKeys: \(layer.animationKeys()) ")
            try! self.mapView.__map.jumpTo(forCamera: camera)
        }
    }

    private func insetsForScreenCoordinate(_ screenCoordinate: CGPoint, in view: UIView) -> UIEdgeInsets {
        let top = screenCoordinate.y
        let left = screenCoordinate.x
        let bottom = view.bounds.size.height - top
        let right = view.bounds.size.width - left
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

public extension EdgeInsets {
    func toUIEdgeInsetsValue() -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(self.top),
                            left: CGFloat(self.left),
                            bottom: CGFloat(self.bottom),
                            right: CGFloat(self.right))
    }
}

public extension UIEdgeInsets {
    func toMBXEdgeInsetsValue() -> EdgeInsets {
        return EdgeInsets(top: Double(self.top),
                          left: Double(self.left),
                          bottom: Double(self.bottom),
                          right: Double(self.right))
    }
}
