//
//  LocationManager.swift
//  PawPal
//
//  Created by Schromeo on 11/20/23.
//

import Foundation
import CoreLocation

//MARK: setting up location manager delegate...
extension MapViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        //MARK: setting up location manager to get the current location...
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //MARK: if the user either allows location while using the app or always...
        if manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways{
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            mapView.buttonLoading.isHidden = true
            mapView.buttonSearch.isHidden = false
            searchNearbyDogParks(from: location)
            locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error.localizedDescription)")
    }
}
