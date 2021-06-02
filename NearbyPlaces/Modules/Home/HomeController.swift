//
//  HomeController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import GoogleMaps
import CoreData

protocol HomeDelegate: AnyObject {
}

// MARK: -

protocol HomeInput: AnyObject {

    var delegate: HomeDelegate? { get set }
}

// MARK: -

protocol HomeControlling: HomeInput {

    func fetchPlaces(for location: CLLocation)
    func viewDidReceiveTapOnViewList()
}

// MARK: -

final class HomeController {

    enum Constants {
        static let placesNumToDisplay = 20
    }

    private let coordinator: HomeCoordinating
    private let placesService: PlacesServiceProtocol

    private let operationQueue = DispatchQueue.init(label: "com.placesManagedContext", qos: .userInitiated)

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NearbyPlaces")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
      }()

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

    @discardableResult
    private func makePlaceModel(from place: Place, queryLocation: CLLocation) -> PlaceModel? {
        let coord = place.coordinate
        guard let latitude = coord?.latitude,
              let longitude = coord?.longitude else { return nil }
        let placeModel = PlaceModel(context: context)
        placeModel.title = place.title
        placeModel.latitude = latitude
        placeModel.longitude = longitude
        placeModel.address = place.address
        placeModel.type = place.type
        placeModel.phone = place.phone
        placeModel.zip = place.zip
        placeModel.score = place.score
        placeModel.queryLatitude = queryLocation.coordinate.latitude
        placeModel.queryLongitude = queryLocation.coordinate.longitude
        return placeModel
    }

    private func makePlace(from placeModel: PlaceModel) -> Place? {
        guard let title = placeModel.title,
              let address = placeModel.address,
              let type = placeModel.type,
              let zipCode = placeModel.zip else { return nil }
        return Place(
            title: title,
            coordinate: CLLocationCoordinate2D(
                latitude: placeModel.latitude,
                longitude: placeModel.longitude),
            address: address,
            type: type,
            phone: placeModel.phone,
            zip: zipCode,
            score: placeModel.score
        )
    }

    private func saveContext() {
        operationQueue.sync {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    context.rollback()
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

    private func savePlaces(_ places: [Place], queryLocation: CLLocation) {
        clearContext()
        operationQueue.sync {
            places.forEach {
                makePlaceModel(from: $0, queryLocation: queryLocation)
            }
        }
        saveContext()
    }

    private func clearContext() {
        if let objects = fetchPlaceModels(),
           !objects.isEmpty {
            deleteObjects(objects)
        }
    }

    private func deleteObjects(_ objects: [NSManagedObject]) {
        operationQueue.sync {
            for object in objects {
                context.delete(object)
            }
        }
        saveContext()
    }

    private func fetchPlaceModels() -> [PlaceModel]? {
        operationQueue.sync {
            let fetchRequest: NSFetchRequest<PlaceModel> = PlaceModel.fetchRequest()
            return try? context.fetch(fetchRequest)
        }
    }
}

// MARK: - HomeControlling

extension HomeController: HomeControlling {

    func fetchPlaces(for location: CLLocation) {

        if let objects = fetchPlaceModels(),
           let firstPlace = objects.first,
           CLLocation(latitude: firstPlace.queryLatitude, longitude: firstPlace.queryLongitude) == location {
            view?.putMarkers(for: objects.compactMap {
                makePlace(from: $0)
            })
            return
        }

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
                self.savePlaces(placesToDisplay, queryLocation: location)
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
