//  LoginViewController.swift
//  PicShare
//  Created by ITZIK KYFE on 25/11/2020.
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var viewLogin: UIView!
    
    @IBAction func logIn(_ sender: UIButton) {
        guard email.text != "" && password.text != "" else {
            self.showLabel(title: "הזן כתובת דוא״ל וסיסמה ‼️")
            return
        }
        
        guard let email = email.text, email.contains("@") else {
            self.showLabel(title: "כתובת דוא״ל אינה תקינה 📧")
            return
        }
        
        guard let password = password.text, password.count > 5 else {
            self.showLabel(title: "הזן סיסמה עם 6 תווים לפחות 🔐")
            return
        }
        
        loadUserIn(email:email, password:password)
    }

    @IBAction func goToProductTableView(_ sender: UIButton) {
        Router.shared.useingTheApp()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeKeyboardWhenTapped()
        self.setBackgroundImage(fileName: "backgroundSingUp")
        self.styleDark(hideNavBarBool:true, email:email, password:password, fullName:nil)
    }
    
    func loadUserIn(email:String, password:String) {
        Auth.auth().signIn(withEmail:email, password:password) { (result, error) in
            if let error = error {
                self.showError(title: "שגיאה", subtitle:  "הפרטים שהזנת שגויים ‼️")
                print("Faild to sign in with error: ", error.localizedDescription)
                print(#function)
                print(#line)
            } else {
                Router.shared.moveToProductTableView()
                print("Successfull logged user in..")
            }
        }
    }
}
