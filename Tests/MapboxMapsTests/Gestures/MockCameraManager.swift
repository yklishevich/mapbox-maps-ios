import Foundation
#if canImport(MapboxMaps)
@testable import MapboxMaps
#else
import MapboxMapsFoundation
@testable import MapboxMapsGestures
#endif

final class MockCameraManager: CameraAnimationsManagerProtocol {

    var mapView: MapView?

    var options = MapCameraOptions()

    struct SetCameraParameters {
        var camera: CameraOptions
    }

    let setCameraStub = Stub<SetCameraParameters, Void>()

    func setCamera(to camera: CameraOptions) {
        setCameraStub.call(
            with: SetCameraParameters(camera: camera))
    }

    struct EaseToCameraParameters {
        var camera: CameraOptions
        var duration: TimeInterval
        var curve: UIView.AnimationCurve
        var completion: AnimationCompletion?
    }

    let easeToStub = Stub<EaseToCameraParameters, CameraAnimator?>(defaultReturnValue: nil)
    func ease(to camera: CameraOptions,
              duration: TimeInterval,
              curve: UIView.AnimationCurve,
              completion: AnimationCompletion?) -> Cancelable? {

        return easeToStub.call(
            with: EaseToCameraParameters(
                camera: camera,
                duration: duration,
                curve: curve,
                completion: completion))
    }

    let cancelAnimationsStub = Stub<Void, Void>()
    func cancelAnimations() {
        cancelAnimationsStub.call()
    }
}
