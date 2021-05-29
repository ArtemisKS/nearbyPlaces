//
//  BaseViewController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        navigationItem.backButtonTitle = ""

        view.backgroundColor = .background
    }
}
