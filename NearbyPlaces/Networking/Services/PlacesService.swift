//
//  PlacesService.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 31.05.2021.
//

import Foundation
import ArcGIS

protocol PlacesServiceProtocol: AnyObject {

    func findPlaces(
        latitude: Double,
        longtitude: Double,
        completion: @escaping (Result<[Place], Error>) -> Void
    )
}

class PlacesService: PlacesServiceProtocol {

    let locatorTask: AGSLocatorTask

    private class var baseURL: String {
        "https://geocode-api.arcgis.com/arcgis/rest/services/World/GeocodeServer"
    }

    init() {
        locatorTask = AGSLocatorTask(url: URL(string: Self.baseURL)!)
        AGSArcGISRuntimeEnvironment.apiKey =
            "AAPK4521ea440c994327852d8de4a2ee4e29O-PuZCk9L1iMeoMTSDxUl10H3eeVVfPSStzJZqaleLBoWUKYMJ4NsJRQePq3yTQL"
    }

    func findPlaces(
        latitude: Double,
        longtitude: Double,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) {
        let parameters = AGSGeocodeParameters()
        parameters.categories = ["Food"]
        parameters.preferredSearchLocation = AGSPoint(
            x: longtitude,
            y: latitude,
            spatialReference: .wgs84()
        )
        parameters.resultAttributeNames = ["*"]

        locatorTask.geocode(
            withSearchText: "",
            parameters: parameters
        ) { (results, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(
                    .success(
                        results?.compactMap { [weak self] in
                            self?.makePlace(from: $0)
                        } ?? []
                    )
                )
            }
        }
    }

    private func makePlace(from result: AGSGeocodeResult) -> Place {

        func getAttr(_ key: String) -> String {
            (result.attributes?[key] as? String) ?? ""
        }

        return Place(
            title: result.label,
            coordinate: result.displayLocation?.toCLLocationCoordinate2D(),
            address: getAttr("Place_addr"),
            type: getAttr("Type"),
            phone: getAttr("Phone").filter { !$0.isWhitespace },
            zip: getAttr("Postal"),
            score: result.score
        )
    }
}
