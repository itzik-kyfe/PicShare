//  Extensions.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import UIKit
import PKHUD

protocol ShowHUD {}
extension ShowHUD {
    func showSuccess(title:String? = nil, subtitle:String? = nil) {
        HUD.flash(.labeledSuccess(title:title, subtitle:subtitle), delay:1)
    }
    
    func showError(title:String? = nil, subtitle:String? = nil) {
        HUD.flash(.labeledError(title:title, subtitle:subtitle), delay:3)
    }
    
    func showProgress(title:String? = nil, subtitle:String? = nil) {
        HUD.show(.labeledProgress(title:title, subtitle:subtitle))
    }
    
    func showLabel(title:String) {
        HUD.flash(.label(title),delay:2)
    }
}

extension UIViewController:ShowHUD {}
extension UIViewController {
    func setBackgroundImage(fileName:String) {
        let backgroundImage = UIImage(named:fileName)
        let imageView:UIImageView
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        self.view.backgroundColor = .black
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func styleDark(hideNavBarBool bool:Bool, email:UITextField, password:UITextField, fullName:UITextField?) {
        self.navigationController?.navigationBar.isHidden = bool
        email.overrideUserInterfaceStyle = .dark
        password.overrideUserInterfaceStyle = .dark
        fullName?.overrideUserInterfaceStyle = .dark
    }
    
    func clearNavigationBar() {
        guard let navBar:UINavigationBar = self.navigationController?.navigationBar else {return}
        navBar.backgroundColor = .black
        navBar.alpha = 0.01
    }
    
    func closeKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target:self, action: #selector(UIViewController.dissmisKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dissmisKeyboard(){
        view.endEditing(true)
    }
    
    func pushViewForKeyboard() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object:nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }
}

