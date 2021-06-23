import MapboxMaps
import UIKit

private let imageSourceId = "add_image"
private let imageLayerId = "image_layer-id"

@objc(ImageSourceExample_Swift)
class ImageSourceExample: UIViewController, ExampleProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 43.457, longitude: -75.789)
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: 4.0))

        let mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        mapView.tintColor = .darkGray
        view.addSubview(mapView)

        mapView.mapboxMap.onNext(.styleLoaded) { _ in
            self.addImage(mapView)
        }
 
    }

    func addImage(_ mapView: MapView) {
        let coordinates1 = [
            [-80.425, 46.437],  // topLeft
            [-71.516, 46.437],  // topRight
            [-71.516, 37.936],  // bottomRight
            [-80.425, 37.936]   // bottomLeft
        ]
        
        let coordinates2 = [
            [-80.425, 66.437],  // topLeft
            [-71.516, 66.437],  // topRight
            [-71.516, 37.936],  // bottomRight
            [-80.425, 37.936]   // bottomLeft
        ]

        // Create an MGLImageSource, used to add georeferenced raster images to a map.
        
        var imageSource = ImageSource()
        imageSource.coordinates = coordinates1


        imageSource.url = Bundle.main.url(forResource: "radar", withExtension: "gif")?.absoluteString
        
        try! mapView.mapboxMap.style.addSource(imageSource, id: imageSourceId)

        var rasterLayer = RasterLayer(id: "image_layer-id")
        rasterLayer.source = "add_image"
        
        //            try! mapView.mapboxMap.style.addLayer(with: properties, layerPosition: .below("water"))
        try! mapView.mapboxMap.style.addLayer(rasterLayer)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
////            var imageSource: ImageSource = try! mapView.mapboxMap.style.source(withId: imageSourceId)
////            imageSource.coordinates = coordinates2
//
//            try! mapView.mapboxMap.style.removeLayer(withId: imageLayerId)
//            try! mapView.mapboxMap.style.removeSource(withId: imageSourceId)
//
//            imageSource.coordinates = coordinates2
//            try! mapView.mapboxMap.style.addSource(imageSource, id: imageSourceId)
//            try! mapView.mapboxMap.style.addLayer(rasterLayer)
//        }
    }
}
