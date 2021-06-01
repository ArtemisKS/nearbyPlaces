//
//  Place.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//

import GoogleMaps

struct Place: Hashable {

    let title: String
    let coordinate: CLLocationCoordinate2D?
    let address: String
    let type: String
    let phone: String?
    let zip: String
    let score: Double

    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
