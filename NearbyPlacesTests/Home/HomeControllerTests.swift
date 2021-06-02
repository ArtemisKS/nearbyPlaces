//
//  HomeControllerTests.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 02.06.2021.
//  
//

// swiftlint:disable implicitly_unwrapped_optional weak_delegate

import MapKit
import XCTest

@testable import NearbyPlaces

final class HomeControllerTests: XCTestCase {

    private final class HomeCoordinatorMock: HomeCoordinating {

        private(set) var didCallOpenPlacesList = false

        func openPlacesList(places: [Place], delegate: PlacesListDelegate?) {
            didCallOpenPlacesList = true
        }
    }

    private final class HomeViewMock: HomeView {

        private(set) var didCallPutMarkers = false
        var didEndFetchingPlaces: (() -> Void)?

        func putMarkers(for places: [Place]) {
            didCallPutMarkers = true
            didEndFetchingPlaces?()
        }

        func showError(message: String) {
        }
    }

    private final class HomeDelegateMock: HomeDelegate {
    }

    private var coordinator: HomeCoordinatorMock!
    private var view: HomeViewMock!
    private var delegate: HomeDelegateMock!
    private var controller: HomeController!

    override func setUp() {
        super.setUp()

        coordinator = .init()
        view = .init()
        delegate = .init()
        controller = .init(coordinator: coordinator, placesService: PlacesService())
        controller.view = view
        controller.delegate = delegate
    }

    override func tearDown() {
        controller = nil
        delegate = nil
        view = nil
        coordinator = nil

        super.tearDown()
    }

    func testFetchPlaces() {
        let expectation = self.expectation(description: "Fetched places successfully")
        view.didEndFetchingPlaces = { expectation.fulfill() }

        controller.fetchPlaces(
            for: CLLocation(latitude: 50, longitude: 30)
        )
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue(self.view.didCallPutMarkers)
            XCTAssertNil(error)
            XCTAssertFalse(self.coordinator.didCallOpenPlacesList)
        }
    }

    func testViewDidReceiveTapOnViewList() {
        controller.viewDidReceiveTapOnViewList()
        XCTAssertFalse(view.didCallPutMarkers)
        XCTAssertTrue(coordinator.didCallOpenPlacesList)
    }
}
