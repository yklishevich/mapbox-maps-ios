import Foundation
import MapboxMobileEvents
import os

extension MMEEventsManager: TelemetryProtocol {
    func send(event: String, withAttributes attributes: [String: Any]) {
        enqueueEvent(withName: event, attributes: attributes)
    }

    func send(event: String) {
        enqueueEvent(withName: event)
    }

    func turnstile() {

        if UserDefaults.standard.bool(forKey: "disableEvents") {
            return
        }

        if #available(iOS 12.0, *) {
            let log = OSLog(subsystem: "com.mapbox.maps", category: "events" )
            let spid = OSSignpostID(log: log)
            os_signpost(.begin, log: log, name: "turnstile", signpostID: spid)
            sendTurnstileEvent()
            os_signpost(.end, log: log, name: "turnstile", signpostID: spid)
        } else {
            sendTurnstileEvent()
        }
    }
}
