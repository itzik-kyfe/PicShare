//  User.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import FirebaseDatabase

class User:FirebaseModel {
    let email:String
    let userID:String
    let fullName:String
    
    init(userID:String, fullName:String, email:String) {
        self.email = email
        self.userID = userID
        self.fullName = fullName
    }
    
    var dict:[String:Any] {
        let dict:[String:Any] = ["userID":userID,
                                 "fullName":fullName,
                                 "email":email]
        return dict
    }
    
    required init?(dict:[String:Any]) {
        guard let userID = dict["userID"] as? String,
              let fullName = dict["fullName"] as? String,
              let email = dict["email"] as? String
        else {
            print("Problem with json: User")
            print(#function)
            print(#line)
            return nil
        }
        self.email = email
        self.userID = userID
        self.fullName = fullName
    }
}

extension User {
    static var userRef:DatabaseReference {
        return Database.database().reference().child("Users")
    }
}
