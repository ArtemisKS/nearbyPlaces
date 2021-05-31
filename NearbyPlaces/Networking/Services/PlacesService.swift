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
        completion: @escaping ([Place]) -> Void
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
        completion: @escaping ([Place]) -> Void
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
                // TODO: handle error
                debugPrint("Error: " + error.localizedDescription)
            } else if let result = results?.first {
                print("""
                    Found \(result.label)
                      at \(result.displayLocation)
                    with score \(result.score)
                    \(result.attributes)
                """)
            }
            completion(results?.compactMap {
                Place(
                    label: $0.label,
                    coordinate: $0.displayLocation?.toCLLocationCoordinate2D(),
                    attributes: $0.attributes,
                    score: $0.score
                )
            } ?? [])
        }
    }
}
