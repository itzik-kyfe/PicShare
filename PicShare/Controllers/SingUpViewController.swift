//  SingUpViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit
import FirebaseAuth

class SingUpViewController: UIViewController {
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func singUp(_ sender: UIButton) {
        guard let fullName = fullName.text else {
            self.showLabel(title: "הזן שם מלא 👤")
            return
        }
        
        guard let password = password.text, password.count > 5 else {
            self.showLabel(title: "הזן סיסמה עם 6 תווים לפחות 🔐")
            return
        }
        
        guard let email = email.text, email.contains("@") else {
            self.showLabel(title: "כתובת דוא״ל אינה תקינה 📧")
            return
        }
        
        createUser(withEmail:email, password:password, fullName:fullName)
    }

    @IBAction func popToSingIn(_ sender: UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeKeyboardWhenTapped()
        self.setBackgroundImage(fileName: "backgroundSingUp")
        self.styleDark(hideNavBarBool:true, email:email, password:password, fullName:fullName)
    }
    
    func createUser(withEmail email:String, password:String, fullName:String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showError(title: "שגיאה", subtitle: "נסה שוב")
                print("Faild to sing user up with error: ", error.localizedDescription)
                print(#function)
                print(#line)
            }
            
            guard let userID = result?.user.uid else {return}
            let values = ["publisher":fullName, "email":email, "userID":userID]
            
            User.userRef.child(userID).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    self.showError(title: "שגיאה", subtitle: "נסה שוב")
                    print("Faild to Update values to database with error: ", error.localizedDescription)
                    print(#function)
                    print(#line)
                }
                self.showSuccess()
                self.navigationController?.popViewController(animated: true)
                print("Successfull signed user up..")
            })
        }
    }
}
