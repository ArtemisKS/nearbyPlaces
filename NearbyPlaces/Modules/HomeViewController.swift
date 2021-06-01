//
//  HomeViewController.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 29.05.2021.
//  
//

import UIKit
import GoogleMaps

struct Place {

    let label: String
    let coordinate: CLLocationCoordinate2D?
    let attributes: [String: Any]?
    let score: Double
}

protocol HomeView: AnyObject {

    func putMarkers(for places: [Place])
}

// MARK: -

final class HomeViewController: BaseViewController {

    enum Constants {
        static let markerColor: UIColor = .red
        static let defaultZoomLevel: Float = 14.0
    }

    enum PlaceDetailsViewState {
        case opened
        case closed
    }

    private let controller: HomeControlling

    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation? {
        didSet {
            updateMapCamera(with: currentLocation)
        }
    }
    private var mapView: GMSMapView!
    private var placeDetailsView: PlaceDetailsView?
    private var placeDetailsViewBottomConstraint: NSLayoutConstraint!
    private var panRecognizer: UIPanGestureRecognizer!
    private var places: [Place] = []
    private var offset: CGFloat = 0
    private var selectedMarker: GMSMarker?

    private var requestPlaces = true

    private var placeDetailsViewState: PlaceDetailsViewState? {
        didSet {
            onPlaceDetailsViewStateChanged(state: placeDetailsViewState)
        }
    }

    init(controller: HomeControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestPlaces(with: currentLocation)
    }

    private func requestPlaces(with location: CLLocation?) {
        guard requestPlaces else {
            return requestPlaces = true
        }
        if let location = location {
            closePlaceDetailView { [weak self] in
                self?.controller.findPlaces(for: location)
            }
        }
    }

    private func setupMap() {

        setupLocationManager()

        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        let camera = GMSCameraPosition.camera(
            withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: Constants.defaultZoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {

    func putMarkers(for places: [Place]) {
        let placesToDisplay = Array(places.prefix(20))
        mapView.clear()
        _ = placesToDisplay.compactMap {
            makeMarker(from: $0)
        }
        self.places = places
    }

    private func makeMarker(from place: Place) -> GMSMarker? {
        guard let coordinate = place.coordinate else { return nil }
        let marker = GMSMarker(position: coordinate)
        marker.title = place.label
        marker.icon = GMSMarker.markerImage(with: Constants.markerColor)
        marker.map = mapView
        return marker
    }
}

extension HomeViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {

        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        locationManager.delegate = self
    }

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }

        currentLocation = location
        debugPrint("Location: \(location)")
    }

    private func updateMapCamera(with location: CLLocation?) {

        guard let location = location else { return }

        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: Constants.defaultZoomLevel)

        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }

        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension HomeViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        selectedMarker?.icon = GMSMarker.markerImage(with: Constants.markerColor)
        selectedMarker = nil
        closePlaceDetailView()
    }

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        requestPlaces(
            with: CLLocation(
                latitude: cameraPosition.target.latitude,
                longitude: cameraPosition.target.longitude
            )
        )
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        selectedMarker?.icon = GMSMarker.markerImage(with: Constants.markerColor)
        marker.icon = GMSMarker.markerImage(with: .blue)
        selectedMarker = marker

        guard let place = places.first(where: { $0.label == marker.title }),
              let attr = place.attributes else { return false }

        func getAttr(_ key: String) -> String {
            (attr[key] as? String) ?? ""
        }

        placeDetailsView?.removeFromSuperview()
        placeDetailsView = PlaceDetailsView()
        placeDetailsView!.setupView(
            title: place.label,
            address: getAttr("Place_addr"),
            type: getAttr("Type"),
            phone: getAttr("Phone").filter { !$0.isWhitespace },
            zip: getAttr("Postal")
        )
        view.addSubview(placeDetailsView!)
        placeDetailsView!.layout { (builder) in
            builder.leading == view.leadingAnchor
            builder.trailing == view.trailingAnchor
        }
        placeDetailsViewBottomConstraint =
            placeDetailsView?.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: detailViewAnimationOffset
        )
        placeDetailsViewBottomConstraint?.isActive = true
        setupGestureRecognizer()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.requestPlaces = false
            self?.mapView.animate(toLocation: marker.position)
        }

        return true
    }
}

// MARK: PlaceDetailsView gesture recognizers logic

private extension HomeViewController {

    private var closedStateHeight: CGFloat { 42 + UIApplication.bottomSafeArea }

    private var detailViewAnimationOffset: CGFloat { 64 }

    func setupGestureRecognizer() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(recognizerEvent))
        placeDetailsView?.addGestureRecognizer(panRecognizer)
    }

    func onRecognizerStateChanged(
        translation: CGPoint,
        minValue: CGFloat
    ) {
        placeDetailsViewBottomConstraint?.constant = translation.y + offset
        if placeDetailsViewBottomConstraint.constant < 0 {
            placeDetailsViewBottomConstraint.constant = 0
        } else if placeDetailsViewBottomConstraint.constant > minValue {
            self.placeDetailsViewBottomConstraint?.constant = minValue
        }
    }

    private func onRecognizerStateEnded(
        translation: CGPoint,
        placeDetailsView: UIView
    ) {
        let viewBottomConstraint = abs(placeDetailsViewBottomConstraint.constant - detailViewAnimationOffset)
        let thresholdViewHeight = placeDetailsView.frame.height / 3
        if translation.y > 0 {
            if viewBottomConstraint <
                thresholdViewHeight {
                placeDetailsViewState = .opened
            } else {
                placeDetailsViewState = .closed
            }
        }
        if translation.y < 0 {
            if viewBottomConstraint < 1.25 * thresholdViewHeight {
                placeDetailsViewState = .opened
            } else {
                placeDetailsViewState = .closed
            }
        }
    }

    @objc private func recognizerEvent() {
        guard let placeDetailsView = placeDetailsView else { return }
        let minValue = placeDetailsView.frame.height - closedStateHeight
        let translation = panRecognizer.translation(in: placeDetailsView)
        switch panRecognizer.state {
        case .began:
            offset = placeDetailsViewBottomConstraint.constant
        case .changed:
            onRecognizerStateChanged(
                translation: translation,
                minValue: minValue
            )
        case .ended, .cancelled:
            onRecognizerStateEnded(
                translation: translation,
                placeDetailsView: placeDetailsView
            )
        default:
            break
        }
    }

    private func onPlaceDetailsViewStateChanged(state: PlaceDetailsViewState?) {
        placeDetailsView?.isHidden = state == nil
        var result: CGFloat = 0
        switch state {
        case .opened:
            result = detailViewAnimationOffset
        case .closed:
            result = (placeDetailsView?.frame.height ?? 0) - closedStateHeight
        case .none:
            placeDetailsViewBottomConstraint.constant = -(placeDetailsView?.frame.height ?? 0)
        }
        if state != nil {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.placeDetailsViewBottomConstraint.constant = result
                self?.view.layoutIfNeeded()
            }
        }
    }

    private func closePlaceDetailView(completion: (() -> Void)? = nil) {
        guard let placeDetailsView = placeDetailsView,
              placeDetailsView.superview != nil else {
            completion?()
            return
        }
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.placeDetailsViewBottomConstraint.constant = placeDetailsView.frame.height
            self?.view.layoutIfNeeded()
        } completion: { _ in
            placeDetailsView.removeFromSuperview()
            completion?()
        }
    }
}
