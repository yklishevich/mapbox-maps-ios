import CoreLocation
import XCTest

#if canImport(MapboxMaps)
@testable import MapboxMaps
#else
@testable import MapboxMapsOrnaments
#endif

class MapboxScaleBarOrnamentViewTests: MapViewIntegrationTestCase {
    var scaleBar : MapboxScaleBarOrnamentView
    override func setUp() {


    }

    func testBarsCount() {
        let initialBarsCount = scaleBar.bars.count
        scaleBar.metersPerPoint = 100
        XCTAssertNotEqual(initialBarsCount, scaleBar.bars.count)
    }
}

class MockMapboxScaleBarOrnamentView: MapboxScaleBarOrnamentView {
    override var maximumWidth: CGFloat {
        return 200.0
    }
}
