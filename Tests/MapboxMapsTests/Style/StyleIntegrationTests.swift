import XCTest

#if canImport(MapboxMaps)
@testable import MapboxMaps
#else
@testable import MapboxMapsStyle
#endif

internal class StyleIntegrationTests: MapViewIntegrationTestCase {

    internal func testUpdateStyleLayer() throws {
        guard
            let style = style else {
            XCTFail("There should be valid MapView and Style objects created by setUp.")
            return
        }

        let expectation = XCTestExpectation(description: "Manipulating style succeeded")
        expectation.expectedFulfillmentCount = 3

        style.uri = .streets

        didFinishLoadingStyle = { _ in

            var newBackgroundLayer = BackgroundLayer(id: "test-id")
            newBackgroundLayer.backgroundColor = .constant(.init(color: .white))

            do {
                try style.addLayer(newBackgroundLayer)
                expectation.fulfill()
            } catch {
                XCTFail("Could not add background layer due to error: \(error)")
            }

            do {
                try style.updateLayer(withId: newBackgroundLayer.id) { (layer: inout BackgroundLayer) throws in
                    XCTAssert(layer.backgroundColor == newBackgroundLayer.backgroundColor)
                    layer.backgroundColor = .constant(.init(color: .blue))
                }
                expectation.fulfill()
            } catch {
                XCTFail("Could not update background layer due to error: \(error)")
            }

            do {
                let retrievedLayer: BackgroundLayer = try style.layer(withId: newBackgroundLayer.id)
                XCTAssert(retrievedLayer.backgroundColor == .constant(.init(color: .blue)))
                expectation.fulfill()
            } catch {
                XCTFail("Could not retrieve background layer due to error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    internal func testMoveStyleLayer() throws {
        guard
            let style = style else {
            XCTFail("There should be valid MapView and Style objects created by setUp.")
            return
        }

        let expectation = XCTestExpectation(description: "Move style layer succeeded")
        expectation.expectedFulfillmentCount = 2

        style.uri = .streets

        didFinishLoadingStyle = { _ in

            let layers = style.styleManager.getStyleLayers()
            let newBackgroundLayer = BackgroundLayer(id: "test-id")

            do {
                try style.addLayer(newBackgroundLayer)
                expectation.fulfill()
            } catch {
                XCTFail("Could not add background layer due to error: \(error)")
            }

            // Move layer, repeatedly
            do {
                for step in stride(from: 0, to: layers.count, by: 3) {

                    try style._moveLayer(withId: "test-id", to: .at(step))

                    // Get layer position
                    let layers = style.styleManager.getStyleLayers()
                    let layerIds = layers.map { $0.id }

                    let position = layerIds.firstIndex(of: "test-id")
                    XCTAssertEqual(position, step)
                }

                expectation.fulfill()
            } catch {
                XCTFail("_moveLayer failed with \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testDecodingOfAllLayersInStreetsv11() {
        guard let style = style else {
            XCTFail("There should be valid MapView and Style objects created by setUp.")
            return
        }
        let expectedLayerCount = 111 // The current number of layers

        let expectation = XCTestExpectation(description: "Getting style layers succeeded")
        expectation.expectedFulfillmentCount = expectedLayerCount

        didFinishLoadingStyle = { _ in
            let layers = style.allLayerIdentifiers
            XCTAssertEqual(layers.count, expectedLayerCount)

            for layer in layers {
                do {
                    _ = try style._layer(withId: layer.id, type: layer.type.layerType)
                    expectation.fulfill()
                } catch {
                    XCTFail("Failed to get line layer with id \(layer.id), error \(error)")
                }
            }
        }

        style.uri = .streets

        wait(for: [expectation], timeout: 5.0)
    }
}
