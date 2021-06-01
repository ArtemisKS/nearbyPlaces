//
//  PlacesListController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//  
//

import Foundation

protocol PlacesListDelegate: AnyObject {
}

// MARK: -

protocol PlacesListInput: AnyObject {

    var delegate: PlacesListDelegate? { get set }
}

// MARK: -

protocol PlacesListControlling: PlacesListInput {

    func viewDidSetup()
}

// MARK: -

final class PlacesListController {

    private let coordinator: PlacesListCoordinating
    private let models: [Place]

    weak var view: PlacesListView?
    weak var delegate: PlacesListDelegate?

    init(
        coordinator: PlacesListCoordinating,
        models: [Place]
    ) {
        self.coordinator = coordinator
        self.models = models
    }
}

// MARK: - PlacesListControlling

extension PlacesListController: PlacesListControlling {

    func viewDidSetup() {
        view?.update(with: models)
    }
}
