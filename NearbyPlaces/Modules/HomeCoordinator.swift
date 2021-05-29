//
//  HomeCoordinator.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import UIKit

protocol HomeCoordinating: AnyObject {
}

// MARK: -

final class HomeCoordinator {

    weak var viewController: UIViewController?
}

// MARK: - HomeCoordinating

extension HomeCoordinator: HomeCoordinating {
}
