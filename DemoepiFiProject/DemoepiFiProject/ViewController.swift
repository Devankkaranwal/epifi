//
//  ViewController.swift
//  DemoepiFiProject
//
//  Created by Devank Karanwal on 11/03/23.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
             locationManager = CLLocationManager()
             locationManager.delegate = self
             locationManager.requestWhenInUseAuthorization()
             locationManager.startUpdatingLocation()
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if let location = locationManager?.location {
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
  
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("latitude---\(latitude)")
            print("longitude---\(longitude)")

            UserDefaults.standard.set(latitude, forKey: "latitude")
            UserDefaults.standard.set(longitude, forKey: "longitude")
            fetchWeatherData(latitude: latitude, longitude: longitude)
            

        }
    
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // Default location is Nagpur, Maharashtra, India
            let latitude = 21.1458
            let longitude = 79.0882

            UserDefaults.standard.set(latitude, forKey: "latitude")
            UserDefaults.standard.set(longitude, forKey: "longitude")
            print("latitude---\(latitude)")
            print("longitude---\(longitude)")
            
            fetchWeatherData(latitude: latitude, longitude: longitude)
        }
    
    
    
       func fetchWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
           
           let baseUrlString = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
           
           let apiKey = "8gY6a5t1S8dHIxdZSMEFJkW9Jtn618Do"
           let latitude = latitude
           let longitude = longitude

           let urlString = "\(baseUrlString)?apikey=\(apiKey)&q=\(latitude),\(longitude)"
           guard let url = URL(string: urlString) else {
               print("Error: Invalid URL")
               return
           }

           let session = URLSession.shared
           let task = session.dataTask(with: url) { data, response, error in
             
               if let error = error {
                   print("Error: \(error.localizedDescription)")
                   return
               }
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode) else {
                   print("Error: Invalid HTTP response")
                   return
               }
               guard let data = data else {
                   print("Error: No data received")
                   return
               }
               if let responseString = String(data: data, encoding: .utf8) {
                   print("Response: \(responseString)")
                  
               }
           }
           task.resume()
       }
}


