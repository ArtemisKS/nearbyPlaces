//
//  PlacesListAssembly.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//  
//

import UIKit

protocol PlacesListAssembling {

    func makePlacesList(places: [Place]) -> AssembledModule<PlacesListInput>
}

// MARK: -

final class PlacesListAssembly {
}

// MARK: - PlacesListAssembling

extension PlacesListAssembly: PlacesListAssembling {

    func makePlacesList(places: [Place]) -> AssembledModule<PlacesListInput> {
        let coordinator = PlacesListCoordinator()
        let controller = PlacesListController(coordinator: coordinator, models: places)
        let viewController = PlacesListViewController(controller: controller)
        controller.view = viewController
        coordinator.viewController = viewController
        return .init(
            viewController: viewController,
            input: controller
        )
    }
}
