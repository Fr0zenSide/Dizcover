//
//  Sample.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

// fixme: Need to use sourcery to manage generation of this methods, like when I upgrade my project from NSCoding to JSONModel
@objc public class Sample: AbstractModel {

    // MARK: - Variables
    // Private variables

    private enum CodingKeys: String, CodingKey {
        case title          = "title_short"
        case fullTitle      = "title"
        case trackNumber    = "track_position"
        case duration       = "duration"
        case rank           = "rank"
        case preview        = "preview"
        case url            = "link"
        case alternative    = "alternative"
        case releaseDate    = "release_date"
        case bpm            = "bpm" // swiftlint:disable:this identifier_name
        case gain           = "gain"
        case share          = "share"
        case contributors   = "contributors"

    }

    // Public variables

    var title: String           = "The Amazing Horse"
    var fullTitle: String?      = "The Amazing Horse"
    var trackNumber: Int        = 0 // track_position
    var duration: Int           = 197
    var rank: Int               = 0
    var preview: String         = "https://www.youtube.com/watch?v=o7cCJqya7wc"
    var url: String             = "https://www.youtube.com/watch?v=o7cCJqya7wc"
    var alternative: String?    = "" // an alternative readable track if the current track is not readable
    // Meta usefull to make more with song data
    var releaseDate: String     = "180117" // todo: add reall date with a formatter to manage Date automatically
    var bpm: Double?            = 0 // swiftlint:disable:this identifier_name
    var gain: Double?           = 0 // Signal strength
    var share: String?          = "https://youtu.be/o7cCJqya7wc" // The share link of the track on Deezer
    var contributors: [String]? = []

    // MARK: - Getter & Setter methods

    override public var description: String {
        var desc = super.description
        desc += " \(CodingKeys.title): \(self.title),"
        desc += " fullTitle: \(self.fullTitle ?? "nil"),"
        desc += " trackNumber: \(self.trackNumber),"
        desc += " duration: \(self.duration),"
        desc += " rank: \(self.rank),"
        desc += " preview: \(self.preview),"
        desc += " url: \(self.url),"
        desc += " alternative: \(self.alternative ?? "nil"),"
        desc += " releaseDate: \(self.releaseDate),"
        desc += " bpm: \(self.bpm ?? 0),"
        desc += " gain: \(self.gain ?? 0),"
        desc += " share: \(self.share ?? "nil"),"
        desc += " contributors: \(self.contributors ?? [])"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create a Sample for convenience with all properties
     
     - Parameter title:
     - Parameter fullTitle:
     - Parameter trackNumber:
     - Parameter duration:
     - Parameter rank:
     - Parameter preview:
     - Parameter url:
     - Parameter alternative:
     - Parameter releaseDate:
     - Parameter bpm:
     - Parameter gain:
     - Parameter share: url to share on socials media
     - Parameter contributors: [String]?
     
     - Parameter albums: collection of albums of this artist
     */
    init(_ title: String? = "The Amazing Horse",
         duration: Int = 97,
         preview: String = "http://i.piccy.info/i7/ceb0b3ae258a185d847ad6c841856468/1-5-5802/27895490/4070688235_055309d5e8.jpg",
         url: String = "https://www.youtube.com/watch?v=o7cCJqya7wc",
         trackNumber: Int? = 0,
         rank: Int? = 0,
         alternative: String? = "",
         releaseDate: String? = "180117",
         fullTitle: String? = "The Amazing Horse",
         bpm: Double? = 0, // swiftlint:disable:this identifier_name
         gain: Double? = 1,
         share: String? = "https://youtu.be/o7cCJqya7wc",
         contributors: [String]? = nil) {

        self.title      = title ?? "The Amazing Horse"
        self.duration   = duration
        self.preview    = preview
        self.url        = url
        self.trackNumber = trackNumber ?? 0
        self.rank       = rank ?? 0
        self.alternative = alternative ?? ""
        self.releaseDate = releaseDate ?? "180117"
        super.init()
        self.fullTitle  = fullTitle ?? "The Amazing Horse"
        self.bpm        = bpm ?? 0
        self.gain       = gain ?? 1
        self.share      = share ?? "https://youtu.be/o7cCJqya7wc"
        self.contributors = contributors ?? []
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
        super.init(json)
        // todo: Need to refacto the next behavior to have a requiredProperties dictionary with {key: type}
        // and test if every key for her type exist on json
        guard let title         = json[CodingKeys.title.stringValue] as? String,
            let trackNumber     = json[CodingKeys.trackNumber.stringValue] as? Int,
            let duration        = json[CodingKeys.duration.stringValue] as? Int,
            let rank            = json[CodingKeys.rank.stringValue] as? Int,
            let preview         = json[CodingKeys.preview.stringValue] as? String,
            let url             = json[CodingKeys.url.stringValue] as? String,
            let alternative     = json[CodingKeys.alternative.stringValue] as? String,
            let releaseDate     = json[CodingKeys.releaseDate.stringValue] as? String
            else {
                let requiredProps: [CodingKeys] = [.title, .trackNumber, .duration, .rank, .preview, .url, .alternative, .releaseDate]
                print("Json parsing error: This model require the next properties: [\(requiredProps.flatMap { "\($0), "})]")
                return nil
        }

        self.title      = title
        self.fullTitle  = json[CodingKeys.fullTitle.rawValue] as? String ?? self.title
        self.trackNumber = trackNumber
        self.duration   = duration
        self.rank       = rank
        self.preview    = preview
        self.url        = url
        self.alternative = alternative
        self.releaseDate = releaseDate
        self.bpm        = json[CodingKeys.bpm.rawValue] as? Double ?? 0
        self.gain       = json[CodingKeys.gain.rawValue] as? Double ?? 1
        self.share      = json[CodingKeys.share.rawValue] as? String ?? nil
        self.contributors = json[CodingKeys.contributors.rawValue] as? [String]
    }

    /**
     Method to create an artist with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        do {
            let values          = try decoder.container(keyedBy: CodingKeys.self)
            self.title          = try values.decode(String.self, forKey: .title)
            self.fullTitle      = try values.decode(String.self, forKey: .fullTitle)
            self.trackNumber    = try values.decode(Int.self, forKey: .trackNumber)
            self.duration       = try values.decode(Int.self, forKey: .duration)
            self.rank           = try values.decode(Int.self, forKey: .rank)
            self.preview        = try values.decode(String.self, forKey: .preview)
            self.url            = try values.decode(String.self, forKey: .url)
            self.alternative    = try values.decode(String.self, forKey: .alternative)
            self.releaseDate    = try values.decode(String.self, forKey: .releaseDate)
            self.bpm            = try values.decode(Double.self, forKey: .bpm)
            self.gain           = try values.decode(Double.self, forKey: .gain)
            self.share          = try values.decode(String.self, forKey: .share)
            self.contributors   = try values.decode([String].self, forKey: .contributors)
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
            try container.encode(title, forKey: .title)
            try container.encode(fullTitle, forKey: .fullTitle)
            try container.encode(trackNumber, forKey: .trackNumber)
            try container.encode(duration, forKey: .duration)
            try container.encode(rank, forKey: .rank)
            try container.encode(preview, forKey: .preview)
            try container.encode(url, forKey: .url)
            try container.encode(alternative, forKey: .alternative)
            try container.encode(releaseDate, forKey: .releaseDate)
            try container.encode(bpm, forKey: .bpm)
            try container.encode(gain, forKey: .gain)
            try container.encode(share, forKey: .share)
            try container.encode(contributors, forKey: .contributors)
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
        return "http://api.deezer.com/track/\(id)"
    }

    // MARK: - Private methods

}
