//  LocationManager.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import CoreLocation

class LocationManager:NSObject {
    let lm = CLLocationManager()
    var location:CLLocation?
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        lm.delegate = self
        startMonitorLocation()
    }
    
    var locationServicesEnabled:Bool {
       return CLLocationManager.locationServicesEnabled()
    }
    
    var hasLocationPermission:Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
}

extension LocationManager:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            lm.requestWhenInUseAuthorization()
            print("Ask Permission")
        case .restricted:
            print("restricted")
        case .denied:
            print("Not Permission")
        case .authorizedAlways, .authorizedWhenInUse:
            startMonitorLocation()
            print("Have Permission")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations[locations.count - 1]
    }
    
    func startMonitorLocation() {
        if hasLocationPermission {
            lm.activityType = .fitness
            lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            lm.startUpdatingLocation()
        }
    }
}

