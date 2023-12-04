//
//  MapViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/20/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let mapView = MapView()
    let locationManager = CLLocationManager()
    let searchBottomView = SearchBottomSheet()
    
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: add action for current location button tap...
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        
        //MARK: add action for bottom search button tap...
        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
        
        //MARK: setting up location manager...
        setupLocationManager()
        
        //MARK: center the map view to current location when the app loads...
        onButtonCurrentLocationTapped()
        
        
        //MARK: Annotating Northeastern University...
        let northeastern = Place(
            title: "Northeastern University",
            coordinate: CLLocationCoordinate2D(latitude: 42.339918, longitude: -71.089797),
            info: "LVX VERITAS VIRTVS"
        )
        
        mapView.mapView.addAnnotation(northeastern)
        mapView.mapView.delegate = self
        
        searchBottomView.tableViewSearchResults.separatorStyle = .none
        
    }
    
    @objc func onButtonCurrentLocationTapped(){
        mapView.mapView.centerToLocation(location: locationManager.location!)
    }
    
    @objc func onButtonSearchTapped(){
        
        //MARK: Setting up bottom search sheet...
        let searchViewController  = SearchViewController()
        searchViewController.delegateToMapView = self
        
        let navForSearch = UINavigationController(rootViewController: searchViewController)
        navForSearch.modalPresentationStyle = .pageSheet
        
        if let searchBottomSheet = navForSearch.sheetPresentationController{
            searchBottomSheet.detents = [.medium(), .large()]
            searchBottomSheet.prefersGrabberVisible = true
        }
        
        present(navForSearch, animated: true)
    }
    
    
    func searchNearbyDogParks(from location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "dog park"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            var allAnnotations = [MKAnnotation]()

            for item in response.mapItems {
                let place = Place(title: item.name ?? "Dog Park", coordinate: item.placemark.coordinate, info: "Dog Park")
                self.mapView.mapView.addAnnotation(place)
                allAnnotations.append(place)
            }

            self.showAnnotationsOnMap(annotations: allAnnotations)
        }
    }

    func showAnnotationsOnMap(annotations: [MKAnnotation]) {
        mapView.mapView.showAnnotations(annotations, animated: true)
    }
    
    //MARK: show selected place on map...
    func showSelectedPlace(placeItem: MKMapItem){
        let coordinate = placeItem.placemark.coordinate
        mapView.mapView.centerToLocation(
            location: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        )
        let place = Place(
            title: placeItem.name!,
            coordinate: coordinate,
            info: placeItem.description
        )
        mapView.mapView.addAnnotation(place)
    }

}

extension MKMapView{
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
