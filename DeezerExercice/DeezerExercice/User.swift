//
//  User.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class User: AbstractModel {
    // MARK: - Variables
    // Private variables

    private enum CodingKeys: String, CodingKey {
        case name
        case photo
        case favorites
    }

    // Public variables

    var name: String
    var photo: String?
    var favorites: [String]?

    // MARK: - Getter & Setter methods

    override public var description: String {
        var desc = super.description
        desc += " \(CodingKeys.name): \(self.name),"
        desc += " photo: \(self.photo ?? "nil"),"
        desc += " favorites: \(self.favorites ?? [])"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create a User
     
     */
    init(_ name: String? = "John Doe", photo: String? = "-", favorites: [String]? = nil) {
        self.name = name ?? "_" // Some one try to declarate my user with a nill value...
        super.init()
        self.photo = photo
        self.favorites = favorites
    }

    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else {
                let requiredProps = ["name"]
                print("Json parsing error: This model require the next properties: [\(requiredProps.flatMap { "\($0), "})]")
                return nil
        }
        self.name = name
        super.init(json)
        self.photo = json["photo"] as? String
        self.favorites = json["favorites"] as? [String]
    }

    /**
     Method to create a user with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required public init(from decoder: Decoder) throws {
        self.name = ""
        try super.init(from: decoder)
        do {
            let values      = try decoder.container(keyedBy: CodingKeys.self)
            self.name       = try values.decode(String.self, forKey: .name)
            self.photo      = try values.decode(String.self, forKey: .photo)
            self.favorites  = try values.decode(Array.self, forKey: .favorites)
        } catch {
            fatalError("Error! When you want to decode your model: \(type(of: self).modelName)")
        }
    }

    /**
     Method to encode your data with the protocol Codable => ref. to NSCoding in ObjC
     
     - Parameter encoder: object require to register all your saved properties to make your model Codable compliante
     - encoder: Need to contain all your Codable/NSCoding properties
     */
    public override func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(photo, forKey: .photo)
            try container.encode(favorites, forKey: .favorites)
        } catch {
            fatalError("Error! When you want to encode your model: \(type(of: self).modelName) > \(self)")
        }
    }

    // MARK: - Public methods

    /**
     Method to get the url of this ressource
     
     - Parameter id: identifier of your ressource
     - Returns: url to request this ressource on api
     
     */
    override class func endpointForID(_ id: String? = "me") -> String {
        // https://api.deezer.com/user/me
        return "https://api.deezer.com/user/\(String(describing: id))"
    }

    // MARK: - Private methods

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
