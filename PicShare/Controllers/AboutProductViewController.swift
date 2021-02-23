//  AboutProductViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit
import MapKit
import MessageUI
import FirebaseStorage

class AboutProductViewController: UIViewController {
    var product:Product?
    
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoLabel: UILabel!
  
    @IBAction func navigation(_ sender: UIButton) {
        guard let latitude = product?.lat,
              let longitude = product?.lon else {return}
        
        actionSheetForNavigation(latitude:latitude, longitude:longitude)
    }
    
    @IBAction func call(_ sender: UIButton) {
        guard let phoneNumber = product?.phoneNumber,
              let callURL = URL(string: "TEL://\(phoneNumber)") else {return}
        
        voiceCall(phoneNumber:phoneNumber, callURL:callURL)
    }
    
    @IBAction func message(_ sender: UIButton) {
        guard let phoneNumber = product?.phoneNumber else {return}
        
        var oldNumber = phoneNumber
        oldNumber.removeFirst()
        let newNumber = String("+972\(oldNumber)")
        let textMessage = "מתעניין/ת במוצר שפרסמת ב-PicShare 📸, אני בסביבה אשמח לקבל פרטים נוספים ואולי גם לתאם הגעה!"
        
        actionSheetForMessages(phoneNumber:phoneNumber, newNumber:newNumber, textMessage:textMessage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        distanceFromUserToPublisher()
        populateTextVsImage()
        setBackgroundImage(fileName: "backgroundView")
    }
    
    func populateTextVsImage() {
        loadPublisherFullName()
        guard let product = product,
              let info = infoLabel.text,
              let price = priceLabel.text,
              let address = addressLabel.text else {return}
        infoLabel.text = info + product.info
        priceLabel.text = price + product.price + "₪"
        addressLabel.text = address + product.address
        mapView.layer.cornerRadius = 5
        mapView.layer.shadowOpacity = 2
        mapView.layer.shadowColor = UIColor.gray.cgColor
        mapView.overrideUserInterfaceStyle = .dark
        imageViewProduct.layer.cornerRadius = 5
        imageViewProduct.layer.shadowOpacity = 2
        imageViewProduct.layer.shadowColor = UIColor.gray.cgColor
        imageViewProduct.sd_setImage(with:product.imageRef)
    }
    
    func loadPublisherFullName() {
        guard let productID = product?.productID else {return}
        Product.productRef.child(productID).child("publisher").child("fullName").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let fullName = snapshot.value as? String, let strongSelf = self else {return}
            strongSelf.publisherNameLabel.text = fullName + " :שם"
        }
    }
    
    func voiceCall(phoneNumber:String, callURL:URL) {
        if UIApplication.shared.canOpenURL(callURL) {
            UIApplication.shared.open(callURL)
        }
    }
   
    func sendMessage(textMessage:String, phoneNumber:String) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = textMessage
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self as MFMessageComposeViewControllerDelegate
            self.present(controller, animated:true, completion:nil)
        }
    }
    
    func sendWhatsapp(whatsappURL:URL, whatsappDownloadURL:URL) {
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            UIApplication.shared.open(whatsappDownloadURL)
        }
    }
    
    func openWaze(wazeURL:URL, wazeNavigateURL:URL, wazeDownloadURL:URL, latitude:Double, longitude:Double) {
        if UIApplication.shared.canOpenURL(wazeURL){
            UIApplication.shared.open(wazeNavigateURL)
        } else {
           UIApplication.shared.open(wazeDownloadURL)
        }
    }
    
    func openAppleMaps(mapsURL:URL, mapsNavigateURL:URL, mapsDownloadURL:URL, latitude:Double, longitude:Double) {
        if UIApplication.shared.canOpenURL(mapsURL) {
            UIApplication.shared.open(mapsNavigateURL)
        } else {
            UIApplication.shared.open(mapsDownloadURL)
        }
    }
    
    func openGoogleMaps(googleMapsURL:URL, googleMapsNavigateURL:URL, googleMapsSafariURL:URL, latitude:Double, longitude:Double) {
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsNavigateURL)
        } else {
            UIApplication.shared.open(googleMapsSafariURL)
        }
    }
    
    func actionSheetForNavigation(latitude:Double, longitude:Double) {
        guard let mapsURL = URL(string: "maps://"),
              let mapsNavigateURL = URL(string: "https://maps.apple.com/?daddr=\(latitude),\(longitude)"),
              let mapsDownloadURL = URL(string: "https://apps.apple.com/us/app/apple-maps/id915056765") else {return}

        guard let wazeURL = URL(string: "waze://"),
              let wazeNavigationURL = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes"),
              let wazeDownloadURL = URL(string:"https://apps.apple.com/us/app/waze-navigation-live-traffic/id323229106")  else {return}

        guard let googleMapsURL = URL(string: "comgooglemaps://"),
              let googleMapsNavigateURL = URL(string: "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic"),
              let googleMapsSafariURL = URL(string: "https://www.google.com/maps/?q=\(latitude),\(longitude)") else {return}
        
        let actionSheet = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        let wazeAction = UIAlertAction(title: "Waze", style: .default) { (action)-> Void in
            self.openWaze(wazeURL:wazeURL,
                          wazeNavigateURL:wazeNavigationURL,
                          wazeDownloadURL:wazeDownloadURL,
                          latitude:latitude, longitude:longitude)
        }
        actionSheet.addAction(wazeAction)
        
        let appleMapsAction = UIAlertAction(title: "Maps", style: .default) { (action)-> Void in
            self.openAppleMaps(mapsURL:mapsURL,
                               mapsNavigateURL:mapsNavigateURL,
                               mapsDownloadURL:mapsDownloadURL,
                               latitude:latitude, longitude:longitude)
        }
        actionSheet.addAction(appleMapsAction)
        
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { (action)-> Void in
            self.openGoogleMaps(googleMapsURL:googleMapsURL,
                                googleMapsNavigateURL:googleMapsNavigateURL,
                                googleMapsSafariURL:googleMapsSafariURL,
                                latitude:latitude, longitude:longitude)
        }
        actionSheet.addAction(googleMapsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated:true, completion:nil)
    }
    
    func actionSheetForMessages(phoneNumber:String, newNumber:String, textMessage:String) {
        guard let textMessageURL = textMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let whatsappURL = URL(string: "whatsapp://send?phone=\(newNumber)&text=\(textMessageURL)"),
              let whatsappDownloadURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997") else {return}
        
        let actionSheet = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        let messageAction = UIAlertAction(title: "Message", style: .default) { (action)-> Void in
            self.sendMessage(textMessage:textMessage, phoneNumber:phoneNumber)
        }
        actionSheet.addAction(messageAction)
        
        let whatsappAction = UIAlertAction(title: "Whatsapp", style: .default) { (action)-> Void in
            self.sendWhatsapp(whatsappURL:whatsappURL, whatsappDownloadURL:whatsappDownloadURL)
        }
        actionSheet.addAction(whatsappAction)
           
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated:true, completion:nil)
    }
    
    func distanceFromUserToPublisher() {
        guard let userCoordinate = LocationManager.shared.location?.coordinate,
              let publisherLat = product?.lat, let publisherLon = product?.lon else {return}
        
        let userLocation = MKMapItem(placemark:MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:userCoordinate.latitude,longitude:userCoordinate.longitude)))
        let publisherLocation = MKMapItem(placemark:MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:publisherLat,longitude:publisherLon)))
        
        zoomIn(userCoordinate:userCoordinate)
        addAnnotation(publisherCoordinate:publisherLocation.placemark.coordinate, userCoordinate:userCoordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = userLocation
        directionRequest.destination = publisherLocation
        
        // MARK: Polyline:
        directionRequest.source = MKMapItem(placemark:userLocation.placemark)
        directionRequest.destination = MKMapItem(placemark: publisherLocation.placemark)
        directionRequest.transportType = .automobile
        // // // // \\ \\ \\ \\
        
        let directions = MKDirections(request:directionRequest)
        directions.calculate { (response, error) in
            guard let distance = response?.routes.first?.distance else {
                print("Error: \(String(describing:error))")
                print(#function)
                print(#line)
                return
            }
            let distanceToMeters = String(distance)
            let distanceArray = distanceToMeters.components(separatedBy: ".")
            let newDistance = distanceArray[0]
            self.distanceLabel.text = ("\(newDistance) מטר ממך")
            
            // MARK: Polyline:
            guard let route = response?.routes[0].polyline else {return}
            self.mapView.addOverlay(route, level: .aboveRoads)
            let rect = route.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated:true)
            // // // // \\ \\ \\ \\
        }
    }
 
    func zoomIn(userCoordinate:CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center:userCoordinate, latitudinalMeters:1000, longitudinalMeters:1000)
        mapView.setRegion(region, animated:true)
    }
  
    func addAnnotation(publisherCoordinate:CLLocationCoordinate2D, userCoordinate:CLLocationCoordinate2D) {
        let publisherAnnotation = MKPointAnnotation()
        publisherAnnotation.coordinate = publisherCoordinate
        publisherAnnotation.title = "מוכר"
        mapView.addAnnotation(publisherAnnotation)
        
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userCoordinate
        userAnnotation.title = "אני"
        mapView.addAnnotation(userAnnotation)
    }
}

extension AboutProductViewController: MKMapViewDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated:true, completion:nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyineRender = MKPolylineRenderer(overlay:overlay)
        polyineRender.strokeColor = UIColor.green
        polyineRender.lineWidth = 4.0
        return polyineRender
    }
}
