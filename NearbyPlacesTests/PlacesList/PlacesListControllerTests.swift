//
//  PlacesListControllerTests.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 02.06.2021.
//  
//

// swiftlint:disable implicitly_unwrapped_optional weak_delegate

import XCTest

@testable import NearbyPlaces

final class PlacesListControllerTests: XCTestCase {

    private final class PlacesListCoordinatorMock: PlacesListCoordinating {
    }

    private final class PlacesListViewMock: PlacesListView {

        private(set) var didCallUpdate = false

        func update(with models: [Place]) {
            didCallUpdate = true
        }
    }

    private final class PlacesListDelegateMock: PlacesListDelegate {
    }

    private var coordinator: PlacesListCoordinatorMock!
    private var view: PlacesListViewMock!
    private var delegate: PlacesListDelegateMock!
    private var controller: PlacesListController!

    override func setUp() {
        super.setUp()

        coordinator = .init()
        view = .init()
        delegate = .init()
        controller = .init(coordinator: coordinator, models: [])
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

    func testViewDidSetup() {
        controller.viewDidSetup()
        XCTAssertTrue(view.didCallUpdate)
    }
}
