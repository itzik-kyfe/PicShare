//  ProductTableViewCell.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import FirebaseStorage
import FirebaseUI
import MapKit
import UIKit
 
class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func populate(product:Product) {
        priceLabel.text = product.price + "₪"
        addressLabel.text = product.address
        infoLabel.text = product.info
        imageProduct.sd_setImage(with:product.imageRef)
        imageProduct.layer.shadowColor = UIColor.gray.cgColor
        imageProduct.layer.shadowOpacity = 2
        imageProduct.layer.cornerRadius = 5
        distanceFromAddressToAddress(publisherLat:product.lat,
                                      publisherLon:product.lon)
    }

    func distanceFromAddressToAddress(publisherLat:Double, publisherLon:Double) {
        guard let userCoordinate = LocationManager.shared.location?.coordinate else {return}
        let userLocation = MKMapItem(placemark:MKPlacemark(coordinate:userCoordinate))
        let publisherLocation = MKMapItem(placemark:MKPlacemark(coordinate:
                                  CLLocationCoordinate2D(latitude:publisherLat,
                                                         longitude:publisherLon)))
        let directionRequest = MKDirections.Request()
        directionRequest.source = userLocation
        directionRequest.destination = publisherLocation
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let distance = response?.routes.first?.distance else {
                print("Error: \(String(describing: error?.localizedDescription))")
                print(#function)
                print(#line)
                return
            }
            let distanceToMeters = String(distance)
            let distanceStringArray = distanceToMeters.components(separatedBy: ".")
            let newDistance = distanceStringArray[0]
            self.distanceLabel.text = ("\(newDistance) מטר ממך")
        }
    }
}
