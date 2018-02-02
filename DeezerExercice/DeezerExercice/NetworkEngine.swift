//
//  NetworkEngine.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 18/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import UIKit
// Internal behavior write here because enum does not support on ObjC
@objc public enum APIKeyEndPointType: Int {
    case artist
    case searchArtist
}

@objc class APIKeyEndPoint: NSObject {
    var type: APIKeyEndPointType!

    init(_ type: APIKeyEndPointType) {
        super.init()
        self.type = type
    }

    func endPoint(_ id: String? = "") -> String {
        var route = "https://youtu.be/OWFBqiUgspg"
        switch self.type {
        case .artist:
            if id != nil {
                route = Artist.endpointForID(id!)
            }
        case .searchArtist:
            if id != nil {
                route = "https://api.deezer.com/search?q=" + id!
            }
        default:
            print("Warning! If you see this message you need to manage the default behavior here...")
            route = "https://youtu.be/OWFBqiUgspg"
        }
        return route
    }
}

@objc class NetworkEngineResult: NSObject {
    var success: Any?// [String: Any]?//(response: [String: Any]?)
    var error: String?

    public override init() {
        super.init()
    }
}

@objc class NetworkEngine: NSObject {
    // MARK: - Variables
    // Private variables

    private var _cache = NSCache<NSString, NSObject>()
    private var _cacheKey = "network.cache"

    // Public variables

    // Doesn't work in ObjC ?
    /*
    public enum APIKeyEndPoint {
        case artist
        case searchArtist(name: String)
        
        func endPoint(_ id: String? = "") -> String {
            var route: String = "https://youtu.be/OWFBqiUgspg"
            switch self {
            case .artist:
                if id != nil {
                    route = Artist.endpointForID(id!)
                }
            case .searchArtist:
                if id != nil {
                    route = "https://api.deezer.com/search?q=" + id!
                }
            default:
                print("Warning! If you see this message you need to manage the default behavior here...")
                route = "https://youtu.be/OWFBqiUgspg"
            }
            return route
        }
    }
    */

    // Doesn't work in ObjC ?
    /*
    public enum NetworkEngineResult {
        case success(response: [String: Any]?)
        case error(error: String)
    }
 */

    // MARK: - Getter & Setter methods

    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    override init() {
        super.init()

        let defaults = UserDefaults.standard
        if let cache = defaults.object(forKey: _cacheKey) as? NSCache<NSString, NSObject> {
            _cache = cache
        } else {
            _cache = NSCache()
        }
    }

    // MARK: - Init behaviors

    // MARK: - Public methods

    // Mark: Method to manage get
    func getRessource(for key: APIKeyEndPoint, with data: [String: Any], complete: @escaping ((_ result: NetworkEngineResult) -> Void)) {
        guard let id = data["id"] as? String else {
            // todo manage execption here late
            print("Warning! you doesn't have a property id on your data: \(data)")
            return
        }

        guard let url = URL(string: key.endPoint(id)) else {
            fatalError("Error! I can create an url with this context.")
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if error != nil {
                let completeArgs = NetworkEngineResult()
                completeArgs.error = "My custom error message"
                complete(completeArgs)
//                complete(.error(error: "My custom error message"))
                return
            }

            var result = [String: Any]()
            result["message"] = "Success on for your request: \(url)"
            print("Request succeeded for: \(url)")
            if data != nil {
                result["data"] = data!
                do {
                    if let parsedResult: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                        result["json"] = parsedResult
                    }
                } catch {
                    print("Error! This data is not a json compliante.")
                }
            }
            let completeArgs = NetworkEngineResult()
            completeArgs.success = result
            complete(completeArgs)
//            complete(.success(response: result))
        })
        task.resume()
    }

    // todo: Change saving cache method because the UserDefaults data is not make for that
    // MARK: Method to add CRUD on cache
    func saveCache() {
        let defaults = UserDefaults.standard
        defaults.set(_cache, forKey: _cacheKey)
        defaults.synchronize()
    }

    func deleteCache() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: _cacheKey)
        defaults.synchronize()
    }

    // MARK: Method to manage cache
    func addToCache(for key: String, data: NSObject) {
        _cache.setObject(data, forKey: key as NSString)
    }

    func getToCache(from key: String) -> NSObject? {
        return _cache.object(forKey: key as NSString)
    }

    // MARK: - Private methods

    // MARK: - Delegates methods

}
