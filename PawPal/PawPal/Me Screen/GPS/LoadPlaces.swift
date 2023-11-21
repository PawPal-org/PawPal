//
//  LoadPlaces.swift
//  PawPal
//
//  Created by Schromeo on 11/20/23.
//

import Foundation
import CoreLocation
import MapKit

extension MapViewController{
    func loadPlacesAround(query: String){
        //MARK: initializing the notification center...
        let notificationCenter = NotificationCenter.default
        
        var mapItems = [MKMapItem]()
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query

        // Set the region to an associated map view's region.
        searchRequest.region = mapView.mapView.region

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                // Handle the error.
                return
            }
            mapItems = response.mapItems
            
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location {
                    print("\(name), \(location)")
                }
            }
            
            //MARK: posting the search results...
            notificationCenter.post(name: .placesFromMap, object: mapItems)
        }
    }
}
