//  FirebaseModel.swift
//  PicShare
//  Created by ITZIK KYFE on 30/11/2020.
import Foundation

protocol FirebaseModel {
    var dict:[String:Any]{get}
    
    init?(dict:[String:Any])
}

extension FirebaseModel {
    static var formatter:ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFullDate]
        return formatter
    }
}
