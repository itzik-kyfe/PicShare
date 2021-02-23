//  LocationServicesRequestViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit

class LocationServicesRequestViewController: UIViewController {
 
    @IBAction func openSetting(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
