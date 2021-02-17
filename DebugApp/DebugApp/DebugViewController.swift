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



        mapView.on(.mapLoadingFinished) { (_) in
            print("** Animation Started")

//
            let animator = UIViewPropertyAnimator(duration: 10, curve: .linear) {
                self.mapView.cameraView.bearing = 90.0
            }

//            let animator = UIViewPropertyAnimator(duration: 10, dampingRatio: 0.1) {
//                self.mapView.cameraView.bearing = 90.0
//            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                animator.stopAnimation(true)
            }

            animator.addCompletion { (_) in
                print("** Animation completed")
            }
            animator.startAnimation()

        }

        self.view.addSubview(mapView)
    }
}
