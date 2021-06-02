//
//  CLLocation.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 02.06.2021.
//

import MapKit

extension CLLocation {

    static func == (lhs: CLLocation, rhs: CLLocation) -> Bool {
        let roundingPlace = 3
        return
            lhs.coordinate.latitude.rounded(toPlaces: roundingPlace) ==
            rhs.coordinate.latitude.rounded(toPlaces: roundingPlace) &&
            lhs.coordinate.longitude.rounded(toPlaces: roundingPlace) ==
            rhs.coordinate.longitude.rounded(toPlaces: roundingPlace)
    }
}
