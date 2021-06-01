//
//  PlacesListCoordinator.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//  
//

import UIKit

protocol PlacesListCoordinating: AnyObject {
}

// MARK: -

final class PlacesListCoordinator {

    weak var viewController: UIViewController?
}

// MARK: - PlacesListCoordinating

extension PlacesListCoordinator: PlacesListCoordinating {
}
