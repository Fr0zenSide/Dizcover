//
//  Album.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class Album: AbstractModel {
    // MARK: - Variables
    // Private variables

    private enum CodingKeys: String, CodingKey {
        case name
        case thumb
        case cover
        case samples
    }

    // Public variables

    var name: String
    var thumb: String?
    var cover: String?
    var samples: [Sample]?

    // MARK: - Getter & Setter methods

    override public var description: String {
        var desc = super.description
        desc += " \(CodingKeys.name): \(self.name),"
        desc += " thumb: \(self.thumb ?? "nil"),"
        desc += " cover: \(self.cover ?? "nil"),"
        desc += " samples: \(self.samples ?? [])"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create an Album
     
     - Parameter name: album name
     - Parameter thumb: url for the cover's preview of this album
     - Parameter cover: url for the cover of this album
     - Parameter samples: collection of samples
     */
    init(_ name: String? = "John Doe", thumb: String? = "-", cover: String? = "-", samples: [Sample]? = nil) {
        self.name       = name ?? "_" // Some one try to declarate my user with a nill value...
        super.init()
        self.thumb      = thumb
        self.cover      = cover
        self.samples    = samples
    }

    /**
     Method to create an album for convenience with a json
     
     - Parameter json: is a dictionary
     Require the next properties:
     - id: UUID
     - name: String
     Optional properties:
     - thumb: String
     - cover: String
     - samples: [Sample]
     */
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else {
            let requiredProps = ["name"]
            print("Json parsing error: This model require the next properties: [\(requiredProps.flatMap { "\($0), "})]")
            return nil
        }
        self.name = name
        super.init(json)
        self.thumb = json["thumb"] as? String
        self.cover = json["cover"] as? String
        self.samples = json["samples"] as? [Sample]
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
            self.thumb      = try values.decode(String.self, forKey: .thumb)
            self.cover      = try values.decode(String.self, forKey: .cover)
            self.samples    = try values.decode(Array.self, forKey: .samples)
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
            try container.encode(thumb, forKey: .thumb)
            try container.encode(cover, forKey: .cover)
            try container.encode(samples, forKey: .samples)
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
    override class func endpointForID(_ id: String) -> String {
        return "https://api.deezer.com/album/\(id)"
    }

    // MARK: - Private methods

}
