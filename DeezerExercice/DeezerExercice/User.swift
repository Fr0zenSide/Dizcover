//
//  User.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class User: NSObject {
    var id: String
    var name: String
    var photo: String?
    var favorites: [String]?
    
    override public var description: String {
        var desc = super.description
        desc += " id: \(self.id),"
        desc += " name: \(self.name),"
        desc += " photo: \(self.photo ?? "nil"),"
        desc += " favorites: \(self.favorites ?? [])"
        return desc
    }
    
    init(_ name: String? = "John Doe") {
        // FixMe: You can get also an uuid for the next line
        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
        self.name = name ?? "_" // Some one try to declarate my user with a nill value...
        super.init()
    }
    
    convenience init(_ name: String? = "John Doe", photo: String? = "-", favorites: [String]? = nil) {
        self.init(name)
        self.photo = photo
        self.favorites = favorites
    }
}

//struct User {
//    var id: String
//    var name: String
//    var photo: String?
//    var favorites: [String]?
//    
//    init(_ name: String? = "John Doe", photo: String? = "-", favorites: [String]? = nil) {
//        // FixMe: You can get also an uuid for the next line
//        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
//        self.name = name ?? "_"
//        self.photo = photo
//        self.favorites = favorites
//    }
//}

