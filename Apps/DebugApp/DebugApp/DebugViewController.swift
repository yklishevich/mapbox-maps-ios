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
    var animator: UIViewPropertyAnimator?
    var slider: UISlider!
    var resourceOptions: ResourceOptions {
        guard let accessToken = AccountManager.shared.accessToken else {
            fatalError("Access token not set")
        }

        let resourceOptions = ResourceOptions(accessToken: accessToken)
        return resourceOptions
    }

    @objc func sliderValueChanged(_ sender: Any) {
        animator?.fractionComplete = CGFloat(slider.value)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(with: view.bounds, resourceOptions: resourceOptions)
        mapView.update { (mapOptions) in
            mapOptions.location.showUserLocation = true
        }
        self.view.addSubview(mapView)

        slider = UISlider(frame: CGRect(origin: self.view.center, size: CGSize(width: 200, height: 20)))
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)

        self.view.addSubview(slider)


        mapView.on(.mapLoadingFinished) { _ in

            let coordinate1 = CLLocationCoordinate2D(latitude: 39.085006, longitude: -77.150925)
            let cameraOptions1 = CameraOptions(center: coordinate1, padding: nil, anchor: nil, zoom: 12, bearing: nil, pitch: nil)
            self.mapView.cameraManager.setCamera(to: cameraOptions1)

            let sanFrancisco = CLLocationCoordinate2D(latitude: 37.774115479976565, longitude: -122.45613600067855)

            let dc = CLLocationCoordinate2D(latitude: 38.921029472657615, longitude: -77.04221240204367)
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {

                let cameraOptions2 = CameraOptions(center: sanFrancisco, padding: nil, anchor: nil, zoom: 12, bearing: nil, pitch: nil)
                self.animator = self.mapView.cameraManager.fly2(to: cameraOptions2, duration: 10)
//                self.animator?.pausesOnCompletion = true

//                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                    self.animator?.stopAnimation(false)
//                    self.animator?.finishAnimation(at: .current)
//                }
                self.animator?.startAnimation()
            }
        }

    }
}
