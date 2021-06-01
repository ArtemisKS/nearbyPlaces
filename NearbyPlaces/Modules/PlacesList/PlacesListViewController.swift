//
//  PlacesListViewController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 01.06.2021.
//  
//

import UIKit

protocol PlacesListView: AnyObject {

    func update(with models: [Place])
}

// MARK: -

final class PlacesListViewController: BaseViewController {

    enum Constants {
        static let offset: CGFloat = 16
    }

    private let controller: PlacesListControlling

    private lazy var tableView = makeTableView()

    private lazy var models = [Place]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var cellIdentifier: String {
        String(describing: PlaceTableViewCell.self)
    }

    private lazy var footerView: UIView = {
        let view = UIView(
            frame: .init(
                origin: .zero,
                size: CGSize(
                    width: Constants.offset,
                    height: UIApplication.bottomSafeArea +  Constants.offset
                )
            )
        )
        view.backgroundColor = .background
        return view
    }()

    init(controller: PlacesListControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupView() {
        super.setupView()

        navigationItem.title = "Food places nearby"

        view.addSubview(tableView)
        registerCells()
        controller.viewDidSetup()
    }

    private func registerCells() {
        tableView.register(
            PlaceTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
    }
}

// MARK: - PlacesListView

extension PlacesListViewController: PlacesListView {

    func update(with models: [Place]) {
        self.models = models
    }
}

private extension PlacesListViewController {

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = footerView
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
}

// MARK: - UITableViewDataSource

extension PlacesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                as? PlaceTableViewCell else { return UITableViewCell() }
        let model = models[index]
        cell.setupCell(
            title: model.title,
            address: model.address,
            type: model.type,
            phone: model.phone,
            zip: model.zip
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PlacesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        (tableView.cellForRow(at: indexPath) as? PlaceTableViewCell)?.onCellTap(duration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        tableView.endUpdates()
    }
}
