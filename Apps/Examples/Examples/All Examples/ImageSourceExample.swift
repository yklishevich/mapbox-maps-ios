import MapboxMaps
import UIKit

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
        // Set the coordinate bounds for the raster image.
//        let coordinates = CoordinateQuad(
//            topLeft: CLLocationCoordinate2D(latitude: 46.437, longitude: -80.425),
//            bottomLeft: CLLocationCoordinate2D(latitude: 37.936, longitude: -80.425),
//            bottomRight: CLLocationCoordinate2D(latitude: 37.936, longitude: -71.516),
//            topRight: CLLocationCoordinate2D(latitude: 46.437, longitude: -71.516))
        
        let coordinates = [
            [-80.425, 46.437],  // topLeft
            [-71.516, 46.437],  // topRight
            [-71.516, 37.936],  // bottomRight
            [-80.425, 37.936]   // bottomLeft
        ]

        // Create an MGLImageSource, used to add georeferenced raster images to a map.
        
        var imageSource = ImageSource()
        imageSource.coordinates = coordinates
        imageSource.url = Bundle.main.url(forResource: "radar", withExtension: "gif")?.absoluteString
        
        try! mapView.mapboxMap.style.addSource(imageSource, id: "add_image")
        
        var rasterLayer = RasterLayer(id: "image_layer-id")
        rasterLayer.source = "add_image"
        
        //            try! mapView.mapboxMap.style.addLayer(with: properties, layerPosition: .below("water"))
        try! mapView.mapboxMap.style.addLayer(rasterLayer)

            
//            let source = MGLImageSource(identifier: "radar", coordinateQuad: coordinates, image: radarImage)
//            style.addSource(source)
//
//            // Create a raster layer from the MGLImageSource.
//            let radarLayer = MGLRasterStyleLayer(identifier: "radar-layer", source: source)
//
//            // Insert the raster layer below the map's symbol layers.
//            for layer in style.layers.reversed() {
//                if !layer.isKind(of: MGLSymbolStyleLayer.self) {
//                    style.insertLayer(radarLayer, above: layer)
//                    break
//                }
//            }
    }
}
