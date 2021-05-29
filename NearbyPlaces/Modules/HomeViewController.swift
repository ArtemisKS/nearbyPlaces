//
//  HomeViewController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import UIKit

protocol HomeView: AnyObject {
}

// MARK: -

final class HomeViewController: BaseViewController {

    private let controller: HomeControlling

    init(controller: HomeControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabel()
    }

    private func setupLabel() {

        let title = UILabel()
        title.text = "Home Screen"
        title.textColor = .white
        title.sizeToFit()
        view.addSubview(title)
        title.center = view.center
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
}
