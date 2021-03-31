//import UIKit
//import Turf
//import CoreLocation
//
//public struct AnnotationOrchestrator { // equivalent of AnnotationPlugin
//    
//    var mapView: MapView
//    
//    var style: Style { mapView.style }
//    
//    init(mapView: MapView) {
//        self.mapView = mapView
//    }
//    
//    func createPolylineAnnotationManager() -> PolylineAnnotationManager {
//        return PolylineAnnotationManager(style: style)
//    }
//    
//    func createPointAnnotationManager() -> PolylineAnnotationManager {
//        return PointAnnotationManager(style: style, layerID: "layer-id")
//    }
//    
//}
//
//protocol AnnotationManager {
//    var style: Style { get }
//    
//    init(style: Style)
//}
//
//protocol Annotation {
//    
//}
//
//public struct PointAnnotationManager: AnnotationManager {
//    var style: Style
//    var source: GeoJSONSource
//    var layer: SymbolLayer
//    
//    public var iconKeepUpright: Value<Bool>?
//    
//    var featureCollection: FeatureCollection?
//    
//    init(style: Style, layerID: String? = nil) {
//        self.style = style
//        self.source = GeoJSONSource()
//        
//        self.layer = SymbolLayer(id: layerId)
//        
//        style.addSource(source: source, identifier: "my-source")
//        self.layer.source = "my-source"
//        
//        self.layer.layout?.iconImage = .expression(
//            Exp(.get) {
//                "icon-image"
//            }
//        )
//        
//        
//        
//    }
//    
//    // need a bulk version of these CRUD
//    func addPointAnnotation(_ pointAnnotation: PointAnnotation) {
//        
//        // Add to the feature collection held by this class
//        
//        
//        let feature = Feature(.init(pointAnnotation.coordinate))
//        feature.properties["icon-image"] = pointAnnotation.iconImage
//        // repeat for every property
//        source.data = self.featureCollection
//        
//        
//        
//    }
//    
//    func removePointAnnotation(_ pointAnnotation: PointAnnotation) {
//        featureCollection?.features.re
//    }
//    
//}
//
//public struct PointAnnotation: Annotation {
//    
//    public var id: String?
//    
//    public var coordinate: CLLocationCoordinate2D
//    
//    public var iconImage: UIImage?
//    
//    public var circleColor: Value<UIColor> {
//        didSet {
//            if circleColor is expression {
//                e
//            }
//        }
//    }
//    
//    public var iconSize: Double = 1.0
//
//    init() {
//    }
//    
//}
//
//let pointManager: PointAnnotationManager? = nil
//
//var pointAnnotation = PointAnnotation()
//pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
//
//
//pointManager?.addPointAnnotation(pointAnnotation)
//
//
//
//
//
//
//public struct PolylineAnnotationManager: AnnotationManager {
//    
//    var style: Style
//
//    
//    init(style: Style) {
//        self.style = style
//    }
//    
//    
//}
//*/
