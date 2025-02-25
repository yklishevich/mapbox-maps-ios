import UIKit
import MapboxMaps

@objc(LineAnnotationExample)

public class LineAnnotationExample: UIViewController, ExampleProtocol {

    internal var mapView: MapView!
    private var lineAnnotationManager: PolylineAnnotationManager?

    override public func viewDidLoad() {
        super.viewDidLoad()

        let centerCoordinate = CLLocationCoordinate2D(latitude: 39.7128, longitude: -75.0060)
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: 7))

        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Allows the delegate to receive information about map events.
        mapView.mapboxMap.onNext(.mapLoaded) { [weak self] _ in

            // Set up the example
            self?.setupExample()

            // The below line is used for internal testing purposes only.
            self?.finish()
        }
    }

    func setupExample() {

        // Line from New York City, NY to Washington, D.C.
        let lineCoordinates = [
            CLLocationCoordinate2DMake(40.7128, -74.0060),
            CLLocationCoordinate2DMake(38.9072, -77.0369)
        ]

        // Create the line annotation.
        var lineAnnotation = PolylineAnnotation(lineCoordinates: lineCoordinates)

        // Customize the style of the line annotation
        lineAnnotation.lineColor = ColorRepresentable(color: .red)
        lineAnnotation.lineOpacity = 0.8
        lineAnnotation.lineWidth = 10.0

        // Create the PolylineAnnotationManager responsible for managing
        // this line annotations (and others if you so choose)
        let lineAnnnotationManager = mapView.annotations.makePolylineAnnotationManager()

        // Sync the annotation to the manager.
        lineAnnnotationManager.syncAnnotations([lineAnnotation])

        // The annotations added above will show as long as the lineAnnotationManager is alive,
        // so keep a reference to it.
        self.lineAnnotationManager = lineAnnnotationManager
    }
}
