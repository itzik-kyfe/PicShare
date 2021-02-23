//  Router.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import UIKit
import FirebaseAuth

class Router {
    weak var window:UIWindow?
    static let shared = Router()
    
    var isLoggedIn:Bool {
        return Auth.auth().currentUser != nil
    }
    
    var locationSevicesVsPermission:Bool {
        return LocationManager.shared.locationServicesEnabled && LocationManager.shared.hasLocationPermission
    }
    
    private init(){}
    
    func checkLocationServicesVsPermission() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async {[weak self] in
                self?.checkLocationServicesVsPermission()
            }
            return
        }
        
        let fileName = locationSevicesVsPermission ? "Main" : "Location"
        let sb = UIStoryboard(name: fileName, bundle: .main)
        window?.rootViewController = sb.instantiateInitialViewController()
    }
    
    func moveToLogInSinUp() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async {[weak self] in
                self?.moveToLogInSinUp()
            }
            return
        }
        let sb = UIStoryboard(name: "LoginSingUp", bundle: .main)
        window?.rootViewController = sb.instantiateInitialViewController()
    }
    
    func moveToProductTableView() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async {[weak self] in
                self?.moveToProductTableView()
            }
            return
        }
        if (isLoggedIn == true) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        window?.rootViewController = sb.instantiateInitialViewController()
        }
    }
    
    func useingTheApp() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async {[weak self] in
                self?.useingTheApp()
            }
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: .main)
        window?.rootViewController = sb.instantiateInitialViewController()
    }
}


