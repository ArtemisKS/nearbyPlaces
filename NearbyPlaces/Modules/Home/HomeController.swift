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
    func viewDidReceiveTapOnViewList()
}

// MARK: -

final class HomeController {

    enum Constants {
        static let placesNumToDisplay = 20
    }

    private let coordinator: HomeCoordinating
    private let placesService: PlacesServiceProtocol

    private var places: [Place] = []

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
            switch result {
            case .success(let results):
                self.places = results
                let placesToDisplay = Array(
                    results.prefix(Constants.placesNumToDisplay)
                )
                self.view?.putMarkers(for: placesToDisplay)
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }

    func viewDidReceiveTapOnViewList() {
        coordinator.openPlacesList(
            places: places,
            delegate: self
        )
    }
}

// MARK: PlacesListDelegate

extension HomeController: PlacesListDelegate {
}
