//
//  HomeController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import GoogleMaps

protocol HomeDelegate: AnyObject {
}

// MARK: -

protocol HomeInput: AnyObject {

    var delegate: HomeDelegate? { get set }
}

// MARK: -

protocol HomeControlling: HomeInput {

    func findPlaces(for location: CLLocation)
}

// MARK: -

final class HomeController {

    private let coordinator: HomeCoordinating
    private let placesService: PlacesServiceProtocol

    weak var view: HomeView?
    weak var delegate: HomeDelegate?

    init(
        coordinator: HomeCoordinating,
        placesService: PlacesServiceProtocol
    ) {
        self.coordinator = coordinator
        self.placesService = placesService
    }
}

// MARK: - HomeControlling

extension HomeController: HomeControlling {

    func findPlaces(for location: CLLocation) {
        let coordinate = location.coordinate
        placesService.findPlaces(
            latitude: coordinate.latitude,
            longtitude: coordinate.longitude) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.putMarkers(for: result)
        }
    }
}
