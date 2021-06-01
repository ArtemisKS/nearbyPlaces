//
//  HomeAssembly.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import UIKit

protocol HomeAssembling {

    func makeHome() -> UIViewController
}

// MARK: -

final class HomeAssembly {

    private let placesListAssembly: PlacesListAssembling

    private let placesService: PlacesServiceProtocol

    init(
        placesListAssembly: PlacesListAssembling,
        placesService: PlacesServiceProtocol
    ) {
        self.placesListAssembly = placesListAssembly
        self.placesService = placesService
    }
}

// MARK: - HomeAssembling

extension HomeAssembly: HomeAssembling {

    func makeHome() -> UIViewController {
        let coordinator = HomeCoordinator(makePlacesList: placesListAssembly.makePlacesList)
        let controller = HomeController(
            coordinator: coordinator,
            placesService: placesService
        )
        let viewController = HomeViewController(controller: controller)
        controller.view = viewController
        coordinator.viewController = viewController
        return viewController
    }
}
