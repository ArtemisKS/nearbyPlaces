//
//  Collection.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Index == Int {

    subscript(safe range: Range<Index>) -> [Element]? {
        range.compactMap { index -> Element? in
            indices.contains(index) ? self[index] : nil
        }
    }
}
