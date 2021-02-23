//  CreateProductViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit
import FirebaseAuth
import CoreLocation

class CreateProductViewController: UIViewController {
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var infoProductTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var leftBarItem: UINavigationItem!
    @IBOutlet weak var senderCreatProduct: UIButton!
    
    @IBAction func btnTakeImage(_ sender: UIButton) {
        takeImage()
    }
    
    @IBAction func btnCreateProduct(_ sender: UIButton) {
        if Router.shared.isLoggedIn == false {
            self.showError(title: "שגיאה", subtitle: "ראשית עלייך להתחבר ‼️")
        } else {
            createProduct()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleLight()
        self.pushViewForKeyboard()
        self.closeKeyboardWhenTapped()
        self.setBackgroundImage(fileName: "backgroundView")
        showLableForUser()
    }
    
    func takeImage() {
            let dialog = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
            func handler(_ action:UIAlertAction) {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                if let title = action.title, title == "Camera" &&
                    UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                }
                self.present(picker, animated:true, completion:nil)
            }
            dialog.addAction(UIAlertAction(title:"Camera", style: .destructive, handler:handler(_:)))
            dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
            present(dialog, animated:true, completion:nil)
        }
    
    func showLableForUser() {
        guard Auth.auth().currentUser != nil else {
            self.showLabel(title: "👤 התחבר על מנת להמשיך!")
            return
        }
    }
    
    func createProduct() {
        guard let imageProduct = productImageView.image, productImageView.image != nil else {
            self.showLabel(title:  "📸 הוסף תמונה שתוצג במודעה!")
            return
        }
        
        guard let info = infoProductTextField.text, info.count >= 2 else {
            self.showLabel(title: "💬 מידע על המוצר חסר!")
            return
        }
        
        guard let price = productPriceTextField.text, price.count > 0 else {
            self.showLabel(title:  "💰 מחיר המוצר חסר!")
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.count >= 9 else {
            self.showLabel(title:  "📲 הוסף מספר ליצירת קשר!")
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid, Auth.auth().currentUser?.uid != nil else {
            self.showLabel(title: "👤 התחבר על מנת להמשיך!")
            return
        }
        
        self.showProgress(title: "מפרסם!")
        
        guard let location = LocationManager.shared.location?.coordinate else {return}
        
        getAddress(lat:location.latitude, lon:location.longitude) {[weak self] (address) in
            guard let strongSelf = self else {return}
            strongSelf.getUserDataFromFirebase(callback: {(fullName, email)-> Void in
                let userDict = User(userID:userID, fullName:fullName, email:email)
                let product = Product(info:info, price:price, lat:location.latitude, lon:location.longitude, address:address, phoneNumber:phoneNumber, publisher:userDict.dict)
                
                func afterSave(_ err:Error?, _ success:Bool) {
                    if success {
                        strongSelf.showSuccess()
                        strongSelf.navigationController?.popViewController(animated:true)
                    } else {
                        strongSelf.showError(title: "שגיאה", subtitle: "נסה שנית ❗️")
                        print("Error: \(String(describing: err?.localizedDescription))")
                        print(#function)
                        print(#line)
                        strongSelf.senderCreatProduct.isEnabled = true
                    }
                }
                product.saveProductWithImage(image:imageProduct, callback: afterSave(_:_:))
                strongSelf.senderCreatProduct.isEnabled = false
            })
        }
    }

    func getUserDataFromFirebase(callback: @escaping(_ fullName:String,_ email:String)->Void) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        User.userRef.child(userID).observeSingleEvent(of: .value) {(snapshot) in
            guard let userDict = snapshot.value as? [String:Any],
                  let fullName = userDict["publisher"] as? String,
                  let email = userDict["email"] as? String else {return}
            callback(fullName, email)
        }
    }
    
    func getAddress(lat:Double, lon:Double, callback: @escaping(_ address:String)->Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude:lat, longitude:lon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placeMarks, error) -> Void in
            guard let placeMark:CLPlacemark = placeMarks?[0] else {return}
            guard let address = placeMark.name, placeMark.name != nil
            else {
                if let error = error {
                    print("Error with get address: ", error.localizedDescription)
                    print(#function)
                    print(#line)
                }
                return
            }
            
            var newAddress = address
            if let streetIL = newAddress.range(of: "רחוב") {
                newAddress.removeSubrange(streetIL)
            }
            if let str = newAddress.range(of: "ا") {
                newAddress.removeSubrange(str)
                callback(newAddress)
            } else {
                callback(address)
            }
        })
    }

}

extension CreateProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated:true, completion:nil)
       
        if let image = info[.editedImage] as? UIImage {
            self.productImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion:nil)
    }
    
    func styleLight() {
        infoProductTextField.overrideUserInterfaceStyle = .light
        productPriceTextField.overrideUserInterfaceStyle = .light
        phoneNumberTextField.overrideUserInterfaceStyle = .light
    }
}


