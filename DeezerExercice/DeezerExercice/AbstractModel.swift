//
//  AbstractModel.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 16/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class AbstractModel: NSObject, Codable {
    // MARK: - Variables
    // Private variables

    private enum CodingKeys: String, CodingKey {
        case id
    }

    // Public variables

    var id: String

    // MARK: - Getter & Setter methods

    /**
     Getter to get the name of the current class in String
     */
    public static var modelName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! // Use this to get class name from a static call
//        return NSStringFromClass(type(of: self)) // Use this to get class name from an instance
    }

    /**
     Getter to custom the description display in console when your print an object
     */
    override public var description: String {
        var desc = super.description
        desc += " id: \(self.id),"
        return desc
    }

    // MARK: - Constructors
    /**
     Method to create an abstract model
     
     */
    override init() {
        // fixme: You can get also an uuid for the next line
        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
        super.init()
    }

    /**
     Method to create an AbstractModel instance from a json
     
     - Parameter json: is a dictionary
     Require the next properties:
     - id: UUID
     */
    init?(_ json: [String: Any]) {
        guard let id = json[CodingKeys.id.stringValue] as? String else {
            let requiredProps = [CodingKeys.id.stringValue]
            print("Json parsing error: This model require the next properties: [\(requiredProps.flatMap { "\($0), "})]")
            return nil
        }
        self.id = id
        super.init()
    }

    // Codable Methods

    /**
     Method to create an artist with the decode constructor which ref. to the protocol Codable or NSCoding in ObjC
     
     - Parameter decoder: object which contain all your data in Cadable/NSCoding format
     */
    required public init(from decoder: Decoder) throws {
        self.id = "\(CFAbsoluteTimeGetCurrent())-\(arc4random())"
        super.init()
        do {
            let values  = try decoder.container(keyedBy: CodingKeys.self)
            self.id     = try values.decode(String.self, forKey: .id)
        } catch {
            fatalError("Error! When you want to decode your model: \(type(of: self).modelName)")
        }
    }

    /**
     Method to encode your data with the protocol Codable => ref. to NSCoding in ObjC
     
     - Parameter encoder: object require to register all your saved properties to make your model Codable compliante
     - encoder: Need to contain all your Codable/NSCoding properties
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }

    // MARK: - Public methods

    /**
     Method to get the url of this ressource
     
     - Parameter id: identifier of your ressource
     - Returns: url to request this ressource on api
     - Warning: This is an abstract methods, you need to override it on every child.
     
     */
    class func endpointForID(_ id: String) -> String {
        fatalError("Error! If you see this message, you need to overrige the method endpointForID in \(self.modelName) class")
    }

    // MARK: - Private methods

    // MARK: - Delegate methods

}
