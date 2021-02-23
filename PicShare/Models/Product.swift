//  Product.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import FirebaseDatabase
import FirebaseStorage

class Product:FirebaseModel {
    let publisher:[String:Any]
    let phoneNumber:String
    let productID:String
    let address:String
    let createdAt:Date
    var imageURL:String
    let price:String
    let info:String
    let lat:Double
    let lon:Double
                                                           
    init(info:String, price:String, lat:Double, lon:Double, address:String, phoneNumber:String, publisher:[String:Any]){
        createdAt = Date()
        productID = UUID().uuidString
        self.imageURL = self.productID + ".jpg"
        self.phoneNumber = phoneNumber
        self.publisher = publisher
        self.address = address
        self.price = price
        self.info = info
        self.lat = lat
        self.lon = lon
    }
    
    var dict:[String:Any] {
        let dict:[String:Any] = ["createdAt":Self.formatter.string(from:createdAt),
                                 "phoneNumber":phoneNumber,
                                 "productID":productID,
                                 "publisher":publisher,
                                 "address":address,
                                 "image":imageURL,
                                 "price":price,
                                 "info":info,
                                 "lat":lat,
                                 "lon":lon
                                ]
        return dict
    }
    
    required init?(dict:[String:Any]) {
        guard let publisherDict = dict["publisher"] as? Dictionary<String,Any>,
              let phoneNumber = dict["phoneNumber"] as? String,
              let createdAt = dict["createdAt"] as? String,
              let date = Self.formatter.date(from:createdAt),
              let productID = dict["productID"] as? String,
              let address = dict["address"] as? String,
              let imageURL = dict["image"] as? String,
              let price = dict["price"] as? String,
              let info = dict["info"] as? String,
              let lat = dict["lat"] as? Double,
              let lon = dict["lon"] as? Double,
              let _ = User(dict:publisherDict)
              else {
                print("Problem with json: Product")
                print(#function)
                print(#line)
                return nil
              }
        
        self.publisher = dict["publisher"] as! [String:Any]
        self.phoneNumber = phoneNumber
        self.productID = productID
        self.imageURL = imageURL
        self.address = address
        self.createdAt = date
        self.price = price
        self.info = info
        self.lon = lon
        self.lat = lat
    }
}

extension Product {
    static var productRef:DatabaseReference {
        return Database.database().reference().child("Product")
    }
    
    var imageRef:StorageReference {
        return Storage.storage().reference().child("Products").child(productID + ".jpg")
    }
    
    func saveProduct(callback:@escaping (Error?,Bool)->Void) {
        Product.productRef.child(self.productID).setValue(dict) {(error, dbRef) in
            if let error = error {
                callback(error, false)
                print("Error: \(error.localizedDescription)")
                print(#function)
                print(#line)
                return
            }
            callback(nil, true)
        }
    }
    
    func saveProductWithImage(image:UIImage, callback:@escaping (Error?, Bool)->Void) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            callback(nil, false)
            print(#function)
            print(#line)
            return
        }
        
        imageRef.putData(data, metadata:nil) {(metadata, error) in
            if let error = error {
                callback(error, false)
                print("Error: \(error.localizedDescription)")
                print(#function)
                print(#line)
                return
            }
            self.saveProduct(callback:callback)
        }
    }
}
