import Foundation
import CoreLocation

@objc public protocol LocationConsumer {

    /// Represents whether the locationConsumer is currently tracking
    /// Set this to `false` to stop tracking
    /// Set this to `true` to start tracking
    var shouldTrackLocation: Bool { get set }

    /// New location update received
    func locationUpdate(newLocation: Location)
}

@objc public class Location: NSObject {
    // MARK: Properties

    /// Direction device is pointing
    public let heading: CLHeading?

    /// The exact location of the device
    public let internalLocation: CLLocation

    /// Location coordinates in (lat, long)
    public var coordinate: CLLocationCoordinate2D {
        return self.internalLocation.coordinate
    }

    /// The direction the device is pointed
    public var course: CLLocationDirection {
        return self.internalLocation.course
    }

    public var horizontalAccuracy: CLLocationAccuracy {
        return self.internalLocation.horizontalAccuracy
    }

    public var headingDirection: CLLocationDirection? {
        guard let heading = self.heading else { return nil }

        if heading.trueHeading >= 0 {
            return heading.trueHeading
        }

        return heading.magneticHeading
    }

    // MARK: Initializer
    public init(with location: CLLocation, heading: CLHeading? = nil) {
        self.internalLocation = location
        self.heading = heading
    }
}
