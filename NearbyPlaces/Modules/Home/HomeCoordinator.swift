//
//  HomeCoordinator.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import UIKit

protocol HomeCoordinating: AnyObject {

    func openPlacesList(places: [Place], delegate: PlacesListDelegate?)
}

// MARK: -

final class HomeCoordinator {

    private let makePlacesList: ([Place]) -> AssembledModule<PlacesListInput>

    weak var viewController: UIViewController?

    init(makePlacesList: @escaping ([Place]) -> AssembledModule<PlacesListInput>) {
        self.makePlacesList = makePlacesList
    }
}

// MARK: - HomeCoordinating

extension HomeCoordinator: HomeCoordinating {

    func openPlacesList(places: [Place], delegate: PlacesListDelegate?) {
        let module = makePlacesList(places)
        module.input.delegate = delegate
        let navigationController = UINavigationController(rootViewController: module.viewController)
        viewController?.present(navigationController, animated: true)
    }
}
