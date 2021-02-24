import UIKit
import MapboxMaps
import Turf

/**
 NOTE: This view controller should be used as a scratchpad
 while you develop new features. Changes to this file
 should not be committed.
 */

public class DebugViewController: UIViewController {

    internal var mapView: MapView!

    var resourceOptions: ResourceOptions {
        guard let accessToken = AccountManager.shared.accessToken else {
            fatalError("Access token not set")
        }

        let resourceOptions = ResourceOptions(accessToken: accessToken)
        return resourceOptions
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.mapView = MapView(with: view.bounds, resourceOptions: resourceOptions)
        mapView.update { (mapOptions) in
            mapOptions.location.showUserLocation = true
        }

        mapView.on(.styleFullyLoaded) { [weak self] _ in
            guard let self = self else { return }
            self.updateStyle()
        }
        self.view.addSubview(mapView)
    }

    func updateStyle() {

        let pointFeature = Feature(geometry: Geometry.point(Point(mapView.centerCoordinate)))

        var geoJSONSource = GeoJSONSource()
        geoJSONSource.data = .feature(pointFeature)

        let sourceId = "my-source"
        let layerId = "my-layer"
        let fontStack : [String] = ["Helvetica"]
        var symbolLayer = SymbolLayer(id: layerId)
        symbolLayer.source = sourceId
        // Working
        //        symbolLayer.layout?.textField = .rawString("Hello world!")
        //        symbolLayer.layout?.textFont = fontStack\
        let imageExp = Exp(.image) {
            "some-image"
        }

        let formattedArray : FormattedArray = [
            .subString("format"),
            .subString("hello"),
        ]

        //        symbolLayer.layout?.textField = .formattedArray(formattedArray)
        let formatExp = Exp(.format) {
            "Hello"
            FormatOptions(fontScale: 2.0)
        }


        symbolLayer.layout?.textField = .expression(formatExp)

        let data = try! JSONEncoder().encode(symbolLayer)
        let json : [String: Any] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        print(json.json())

        _ = mapView.style.addSource(source: geoJSONSource, identifier: sourceId)
        let layerReturn = mapView.style.addLayer(layer: symbolLayer, layerPosition: nil)

        switch layerReturn {
        case .success(_):
            print("layer added successfully")
        case .failure(let error):
            print("layer not added : \(error)")
        }

        let getLayerResult = mapView.style.getLayer(with: layerId, type: SymbolLayer.self)

        switch getLayerResult {
        case .success(let layer):
            debugPrint("✅ Got layer: \(layer)")
        case .failure(let error):
            debugPrint("❌ Got error: \(error)")
        }
    }
}


public extension Collection {

    /// Convert self to JSON String.
    /// Returns: the pretty printed JSON string or an empty string if any error occur.
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("json serialization error: \(error)")
            return "{}"
        }
    }
}

