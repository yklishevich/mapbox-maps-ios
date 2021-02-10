import UIKit
import MapboxMaps
import Turf

/**
 NOTE: This view controller should be used as a scratchpad
 while you develop new features. Changes to this file
 should not be committed.
 */

public class DebugViewController: UIViewController {

    @IBOutlet weak var frameGraph: TimeFrameGraph!
    internal var frameGraphEnabled: Bool = false
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

        self.view.addSubview(mapView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBarTap))
        self.mapView.addGestureRecognizer(tap)

        if self.frameGraphEnabled {
            mapView.on(.renderFrameFinished) { (status) in
//                self.frameGraph.updatePath(with: mapView.__map.tim)
            }
        }
    }

    @objc func handleBarTap() {
        print("boop")
    }
}
