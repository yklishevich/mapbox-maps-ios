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
    let identifier = "geoJSON-data-source"
    
    func addSource() {
        var geojsonSrc = GeoJSONSource()
        let feature = Feature(Point(mapView.centerCoordinate))
        geojsonSrc.data = .feature(feature)
        let result = mapView.style.addSource(source: geojsonSrc, identifier: identifier)
        
        switch result {
        case .success(_):
            print("Successfully added source")
        case .failure(let error):
            print("Source not added : \(error)")
        }
    }
    
    func updateSource() {
    
        let newGeojsonString =
        """
        {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "LineString",
            "coordinates": [
              [
                139.273681640625,
                36.01356058518153
              ],
              [
                140.48217773437497,
                37.64903402157866
              ]
            ]
          }
        }
        """
        
        let expected = mapView.mapboxMap.__map.setStyleSourcePropertyForSourceId(identifier, property: "data", value: newGeojsonString)
        if expected.isError() {
            print("Error in updating source! : \(expected.error)")
        }
    }
    
    func addLayer() {
        var lineLayer = LineLayer(id: "my-layer")
        
        lineLayer.source = identifier
        lineLayer.paint?.lineColor = .constant(.init(color: .red))
        lineLayer.paint?.lineWidth = .constant(3.0)
        lineLayer.layout?.lineCap = .constant(.round)
        
        let result = mapView.style.addLayer(layer: lineLayer)
        switch result {
        case .success(_):
            print("Successfully added layer")
        case .failure(let error):
            print("Failed to add layer: \(error)")
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // Set the center coordinate and zoom level.
        let centerCoordinate = CLLocationCoordinate2DMake(35.42486791930558, 136.95556640625)
        
        let camera = CameraOptions(center: centerCoordinate, zoom: 10)
        mapView.camera.setCamera(to: camera)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) { [weak self] in
            print("Adding a source")
            self?.addSource()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
            print("Updating a source")
            self?.updateSource()
            self?.addLayer()
        }
    }
}
