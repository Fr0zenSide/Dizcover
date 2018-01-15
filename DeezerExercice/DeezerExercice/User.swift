//
//  User.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class User: NSObject {
    // MARK: - Variables
    // Private variables

    // Public variables

    var id: String
    var name: String
    var photo: String?
    var favorites: [String]?

    // MARK: - Getter & Setter methods

    override public var description: String {
        var desc = super.description
        desc += " id: \(self.id),"
        desc += " name: \(self.name),"
        desc += " photo: \(self.photo ?? "nil"),"
        desc += " favorites: \(self.favorites ?? [])"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    init(_ name: String? = "John Doe") {
        // fixme: You can get also an uuid for the next line
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

// todo: Try to use struct with a convertor in ObjC later
//struct User {
//    var id: String
//    var name: String
//    var photo: String?
//    var favorites: [String]?
//    
//    init(_ name: String? = "John Doe", photo: String? = "-", favorites: [String]? = nil) {
//        // fixme: You can get also an uuid for the next line
//        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
//        self.name = name ?? "_"
//        self.photo = photo
//        self.favorites = favorites
//    }
//}
