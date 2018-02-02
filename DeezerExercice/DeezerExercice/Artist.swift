//
//  Artist.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

// todo: looks if it possible to implement subscript to make something like self[CodingKeys.] = newValue // For the initializers
@objc public class Artist: AbstractModel {
    // MARK: - Variables
    // Private variables

    private enum CodingKeys: String, CodingKey {
        case name
        case thumb = "picture_small"
        case photo = "picture_big"
        case rank
        case albums
    }

    // Public variables

    var name: String
    var thumb: String?
    var photo: String?
    var rank: Int = 0
    var albums: [Album]?

    // MARK: - Getter & Setter methods

    override public var description: String {
        var desc = super.description
        desc += " \(CodingKeys.name): \(self.name),"
        desc += " thumb: \(self.thumb ?? "nil"),"
        desc += " photo: \(self.photo ?? "nil"),"
        desc += " rank: \(self.rank),"
        desc += " favorites: \(self.albums ?? [])"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create an artist for convenience with all properties
     
     - Parameter name: scene name of this artist
     - Parameter thumb: url of small preview for an artist
     - Parameter photo: url of preview for an artist
     - Parameter albums: collection of albums of this artist
     */
    init(_ name: String? = "The Amazing Horse",
         thumb: String? = "http://i.piccy.info/i7/ceb0b3ae258a185d847ad6c841856468/1-5-5802/27895490/4070688235_055309d5e8.jpg",
         photo: String? = "https://i.ytimg.com/vi/cLZGyORsHzo/maxresdefault.jpg",
         rank: Int? = 0,
         albums: [Album]? = nil) {// https://www.youtube.com/watch?v=o7cCJqya7wc

        self.name = name ?? "The Amazing Horse"
        super.init()
        self.thumb = thumb
        self.photo = photo
        self.rank = rank ?? 0
        self.albums = albums
    }

    /**
     Method to create an artist for convenience with a json
     
     - Parameter json: is a dictionary
     Require the next properties:
     - id: UUID
     - name: String
     Optional properties:
     - thumb: String
     - photo: String
     - rank: Int
     - albums: [Album]
     */
    override init?(_ json: [String: Any]) {
        guard let name = json["name"] as? String else {
                let requiredProps = ["name"]
                print("Json parsing error: This model require the next properties: [\(requiredProps.flatMap { "\($0), "})]")
                return nil
        }
        self.name = name
        super.init(json)
        self.thumb = json[CodingKeys.thumb.rawValue] as? String
        self.photo = json[CodingKeys.photo.rawValue] as? String
        self.rank = Int((json[CodingKeys.rank.rawValue] as? String ?? "0"))!
        self.albums = json[CodingKeys.albums.rawValue] as? [Album]
    }

    /**
     Method to create an artist with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required public init(from decoder: Decoder) throws {
        self.name = ""
        try super.init(from: decoder)
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try values.decode(String.self, forKey: .name)
            self.thumb = try values.decode(String.self, forKey: .thumb)
            self.photo = try values.decode(String.self, forKey: .photo)
            self.rank = try values.decode(Int.self, forKey: .rank)
            self.albums = try values.decode([Album].self, forKey: .albums)
        } catch {
            fatalError("Error! When you want to decode your model: \(type(of: self).modelName) > \(self)")
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
            try container.encode(photo, forKey: .photo)
            try container.encode(rank, forKey: .rank)
            try container.encode(albums, forKey: .albums)
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
        return "https://api.deezer.com/artist/\(id)"
    }

    // MARK: - Private methods

}

/*
 artist =             {
 id = 1670355;
 link = "https://www.deezer.com/artist/1670355";
 name = Lartiste;
 picture = "https://api.deezer.com/artist/1670355/image";
 "picture_big" = "https://e-cdns-images.dzcdn.net/images/artist/5e24e4f4b919c9dcdb49e32ffb67b82f/500x500-000000-80-0-0.jpg";
 "picture_medium" = "https://e-cdns-images.dzcdn.net/images/artist/5e24e4f4b919c9dcdb49e32ffb67b82f/250x250-000000-80-0-0.jpg";
 "picture_small" = "https://e-cdns-images.dzcdn.net/images/artist/5e24e4f4b919c9dcdb49e32ffb67b82f/56x56-000000-80-0-0.jpg";
 "picture_xl" = "https://e-cdns-images.dzcdn.net/images/artist/5e24e4f4b919c9dcdb49e32ffb67b82f/1000x1000-000000-80-0-0.jpg";
 tracklist = "https://api.deezer.com/artist/1670355/top?limit=50";
 type = artist;
 };
*/
