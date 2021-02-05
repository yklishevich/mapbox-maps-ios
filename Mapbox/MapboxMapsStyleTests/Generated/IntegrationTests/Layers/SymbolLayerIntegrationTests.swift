// This file is generated
import XCTest

#if canImport(MapboxMaps)
@testable import MapboxMaps
#else
@testable import MapboxMapsStyle
#endif

class SymbolLayerIntegrationTests: MapViewIntegrationTestCase {

    internal func testBaseClass() throws {
        // Do nothing
    }

    internal func testWaitForIdle() throws {
        guard let style = style else {
            XCTFail("There should be valid MapView and Style objects created by setUp.")
            return
        }

        let successfullyAddedLayerExpectation = XCTestExpectation(description: "Successfully added SymbolLayer to Map")
        successfullyAddedLayerExpectation.expectedFulfillmentCount = 1

        let successfullyRetrievedLayerExpectation = XCTestExpectation(description: "Successfully retrieved SymbolLayer from Map")
        successfullyRetrievedLayerExpectation.expectedFulfillmentCount = 1

        style.styleURL = .streets

        didFinishLoadingStyle = { _ in

            var layer = SymbolLayer(id: "test-id")
            layer.source = "some-source"

            // Add the layer
            let addResult = style.addLayer(layer: layer)

            switch (addResult) {
                case .success(_):
                    successfullyAddedLayerExpectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed to add SymbolLayer because of error: \(error)")
            }

            let setStyleExpected = try! style.styleManager.setStyleLayerPropertyForLayerId("test-id", property: "text-field", value: [
                "format",
                "foo",
                [
                    "font-scale" : 1.2,
                    "text-font" : [ "literal",
                                    [
                                      "Arial"
                                    ]
                                  ],
                    "text-color" : ColorRepresentable(color: .red).colorRepresentation
                ],
                "bar",
                [
                    "font-scale" : 0.8,
                    "text-font" : [ "literal",
                                    [
                                        "Arial"
                                    ]
                                  ],
                    "text-color" : ColorRepresentable(color: .red).colorRepresentation
                ]
            ])

            if setStyleExpected.isError() {
                fatalError("** set style expected is error: \(setStyleExpected.error)")
            } else {
                print("** set style expected is success: \(setStyleExpected.value)")
            }

            let values = try! style.styleManager.getStyleLayerProperties(forLayerId: "test-id")

            print(values.value)

            // Retrieve the layer
            let retrieveResult = style.getLayer(with: "test-id", type: SymbolLayer.self)

            switch (retrieveResult) {
                case .success(let layer):
                    successfullyRetrievedLayerExpectation.fulfill()    
                case .failure(let error):
                    XCTFail("Failed to retreive SymbolLayer because of error: \(error)")   
            }
        }

        wait(for: [successfullyAddedLayerExpectation, successfullyRetrievedLayerExpectation], timeout: 5.0)
    }
}

// End of generated file
