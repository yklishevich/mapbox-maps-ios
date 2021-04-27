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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // Set the center coordinate and zoom level.
        let centerCoordinate = CLLocationCoordinate2DMake(35.42486791930558, 136.95556640625)
        
        let camera = CameraOptions(center: centerCoordinate, zoom: 10)
        mapView.camera.setCamera(to: camera)
        
        mapView.on(.mapLoaded) { [weak self](_) in
            self?.animateBackgroundColorOfLand()
        }
    }
        
    func animateBackgroundColorOfLand() {
        mapView.style.updateLayer(id: "land", type: BackgroundLayer.self) { (layer) in
            layer.paint?.backgroundColor = .constant(.init(color: .red))
            layer.paint?.backgroundColorTransition = .init(duration: 10, delay: 0)
        }
    }
}
