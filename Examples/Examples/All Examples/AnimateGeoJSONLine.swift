import UIKit
import MapboxMaps
import Turf
import CoreLocation


@objc(AnimateGeoJSONLine)
public class AnimateGeoJSONLine: UIViewController, ExampleProtocol {
    
    internal var mapView: MapView!
    var currentIndex = 1
    var timer: Timer?
    var lineLayer: LineLayer!
    var allCoordinates: [CLLocationCoordinate2D]!
    var styleManager: StyleManager?

    public var routeGeoJSONLine = (identifier: "routeLine", source: GeoJSONSource())

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapView(with: view.bounds, resourceOptions: resourceOptions())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736)
        
        mapView.cameraManager.setCamera(centerCoordinate: centerCoordinate,
                                        zoom: 11.0)
        
        allCoordinates = coordinates
        
        // Allows the delegate to receive information about map events.
        mapView.on(.mapLoadingFinished) { [weak self] _ in
            
            guard let self = self else { return }
            self.addLine()
            self.animatePolyline()
            
            // The below line is used for internal testing purposes only.
             self.finish()
        }
    }
    
    func addLine() {
        let coordinate = coordinates[currentIndex]
        // Create a GeoJSON data source.
        routeGeoJSONLine.source.data = .feature(Feature(geometry: Geometry.lineString(LineString([coordinate]))))
        
        var lineLayer = LineLayer(id: "meh")
        lineLayer.filter = Exp(.eq) {
            "$type"
            "LineString"
        }
        lineLayer.source = routeGeoJSONLine.identifier
        lineLayer.paint?.lineColor = .constant(ColorRepresentable(color: UIColor.red))
        
        let lowZoomWidth = 5
        let highZoomWidth = 20
        lineLayer.paint?.lineWidth = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                14
                lowZoomWidth
                18
                highZoomWidth
            }
        )
        lineLayer.layout?.lineCap = .round
        lineLayer.layout?.lineJoin = .round
        
        // Add the lineLayer to the map.
        self.mapView.style.addSource(source: routeGeoJSONLine.source, identifier: routeGeoJSONLine.identifier)
        self.mapView.style.addLayer(layer: lineLayer)
        
    }
    
    func animatePolyline() {
        currentIndex = 1
        
        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        // Update our lineLayer with the current locations.
        updatePolylineWithCoordinates(coordinates: coordinates)
        
        currentIndex += 1
        print(currentIndex)
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        let mutableCoordinates = coordinates

        // Identify the new coordinate to animate to
        routeGeoJSONLine.source.data = .feature(Feature(LineString(mutableCoordinates)))
        let geoJSON = Feature.init(geometry: Geometry.lineString(LineString(mutableCoordinates)))
        _ = self.mapView.style.updateGeoJSON(for: self.routeGeoJSONLine.identifier,
                                                                   with: geoJSON)
    }
    
    var coordinates = [
        (-122.63748, 45.52214),
        (-122.64855, 45.52218),
        (-122.6545, 45.52219),
        (-122.65497, 45.52196),
        (-122.65631, 45.52104),
        (-122.6578, 45.51935),
        (-122.65867, 45.51848),
        (-122.65872, 45.51293),
        (-122.66576, 45.51295),
        (-122.66745, 45.51252),
        (-122.66813, 45.51244),
        (-122.67359, 45.51385),
        (-122.67415, 45.51406),
        (-122.67481, 45.51484),
        (-122.676, 45.51532),
        (-122.68106, 45.51668),
        (-122.68503, 45.50934),
        (-122.68546, 45.50858),
        (-122.6852, 45.50783),
        (-122.68424, 45.50714),
        (-122.68433, 45.50585),
        (-122.68429, 45.50521),
        (-122.68456, 45.50445),
        (-122.68538, 45.50371),
        (-122.68653, 45.50311),
        (-122.68731, 45.50292),
        (-122.68742, 45.50253),
        (-122.6867, 45.50239),
        (-122.68545, 45.5026),
        (-122.68407, 45.50294),
        (-122.68357, 45.50271),
        (-122.68236, 45.50055),
        (-122.68233, 45.49994),
        (-122.68267, 45.49955),
        (-122.68257, 45.49919),
        (-122.68376, 45.49842),
        (-122.68428, 45.49821),
        (-122.68573, 45.49798),
        (-122.68923, 45.49805),
        (-122.68926, 45.49857),
        (-122.68814, 45.49911),
        (-122.68865, 45.49921),
        (-122.6897, 45.49905),
        (-122.69346, 45.49917),
        (-122.69404, 45.49902),
        (-122.69438, 45.49796),
        (-122.69504, 45.49697),
        (-122.69624, 45.49661),
        (-122.69781, 45.4955),
        (-122.69803, 45.49517),
        (-122.69711, 45.49508),
        (-122.69688, 45.4948),
        (-122.69744, 45.49368),
        (-122.69702, 45.49311),
        (-122.69665, 45.49294),
        (-122.69788, 45.49212),
        (-122.69771, 45.49264),
        (-122.69835, 45.49332),
        (-122.7007, 45.49334),
        (-122.70167, 45.49358),
        (-122.70215, 45.49401),
        (-122.70229, 45.49439),
        (-122.70185, 45.49566),
        (-122.70215, 45.49635),
        (-122.70346, 45.49674),
        (-122.70517, 45.49758),
        (-122.70614, 45.49736),
        (-122.70663, 45.49736),
        (-122.70807, 45.49767),
        (-122.70807, 45.49798),
        (-122.70717, 45.49798),
        (-122.70713, 45.4984),
        (-122.70774, 45.49893)
    ].map({CLLocationCoordinate2D(latitude: $0.1, longitude: $0.0)})
}
