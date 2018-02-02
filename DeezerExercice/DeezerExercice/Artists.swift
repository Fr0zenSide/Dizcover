//
//  Artists.swift
//  DeezerExercice
//
//  Created by jeoffrey on 17/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation

@objc public class Artists: NSObject {

    // MARK: - Variables
    // Private variables

    private var _cacheKeyPatern = "artists.name."

    // Public variables

    var list: [Artist] = []

    // MARK: - Getter & Setter methods

    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    override public init() {
        super.init()
    }

    convenience public init(for searchName: String) {
        self.init()

        search(for: searchName)
    }

    /*
    public init(_ json: [[String: Any]]) {
        super.init()

        let ar = Artist()

        ar.name = ""
        for child in json {
            print("child: \(child)")

            let mappedChild = child.map({ (key: String, value: Any) -> [String: Any] in
                print("key: \(key)")
                print("value: \(value)")
                if key == "album" {

                } else if key == "artist" {

                    if let v = value as? [String: Any] {
                        print("v: \(v)")
//                        let dddd = getDictFromArrayOfKeyValues(data: v)
//                        print("dddd: \(dddd)")
                        let data = v.map { return [$0: $1] }
                        print("data: \(data)")
                        return [key: data]
                    }

                } else {
                    return [key: value]
                }
                return [key: value]
            })
            print("mappedChild: \(mappedChild)")

            var data: [String: Any] = [:]
//            var data2 = [String: Any]()
            let flattedChild = child.map({ (key: String, value: Any) -> [String: Any] in
                print("key: \(key)")
                print("value: \(value)")
                return [key: value]
            })
//            {
//                print("$0: \($0)")
//                return [$0.key: $0.value]
//            }
            print("flattedChild: \(flattedChild)")
//            flattedChild.flatMap {
//                print("$0: \($0)")
//                return $0
//            }
            print("flattedChild: \(flattedChild)")

            for node in child {
                if node.key == "album" {
//                    data["albums"] = node.value
                    if let albumNode = node.value as? [String: Any] {
                        var albumData = [String: Any]()
                        poplateData(in: &albumData, with: albumNode)
                        data["albums"] = albumData
                    }
//                    poplateData(in: &albumData, with: node.value)
//                    data["albums"] = albumData
                } else if node.key == "artist" {
                    print("type(of: node.value): \(type(of: node.value))")
                    print("node.value: \(node.value)")
                    if let artistNode = node.value as? [String: Any] {
                        poplateData(in: &data, with: artistNode)
                    }
//                    if let artistsNode: [String:Any] = node.value as! [String:Any] {
//                        poplateData(in: &data, with: artistsNode)
//                    }
                } else {
                    data[node.key] = node.value
                }
            }
            if let currentArtist = Artist(data) {
                print("currentArtist: \(currentArtist)")
                list.append(currentArtist)
            }
//            for (key, value) in child.enumerated() {
//                print("child[\(key)]: \(value)")
////                if key == "album" {
////
////                } else if key == "artist" {
////
////                }
////                if key == "album" && key != "artist" {
////                    data[key] = value
////                }
//            }
//            data =
//            data = child["artist"]
//            data[""] =
//            data[""] =
//            let artist = Artist(data)
//            print("child[\"album\"]: \(child["album"])")
//            print("child[\"artist\"]: \(child["artist"])")
//            print("child[\"preview\"]: \(child["preview"])")
        }

        print("list: \(list)")
    }
    */
//    public init(with data: Data) {
//        do {
//            if let artistJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                let artists = Artist(json: artistJSON) {
//                // created a TODO object
//            }
//        } catch {
//            print("Error! Your data are not loaded ")
//        }
//    }

    // MARK: - Init behaviors

    // MARK: - Public methods

    func populate(_ json: [String: Any]) {
        print("\n\n")
        
        if let artistsRaw = json["data"] as? [[String: Any]] {
            let artists = artistsRaw.map { (artistRawData) -> Artist? in
//                print("artist raw data: \(artistRawData)")
                var data = [String: Any]()
                artistRawData.forEach {
                    data[$0.0] = $0.1
                }

                if let artistDetails = data["artist"] as? [String: Any] {
                print("type(of: rawArtist): \(type(of: artistDetails))")
                print("rawArtist: \(artistDetails)")
                    artistDetails.forEach({ (key, value) in
                        if key != "type" {
                            data[key] = value
                        }
                    })
                }


                print("data: \(data)")

                var artist = Artist(data)
                print("artist: \(artist)")
                return artist
            }
            print("artits: \(artists)")
            list = artists
            return
        }

        for child in json {
            var data = [String :AnyObject]()// = [:]
//            child.foreach
//            data = child
            data.removeValue(forKey: "artist")
//            data.remove(at: <#T##Dictionary<String, AnyObject>.Index#>)
//            data[""] =
//            var data = [:]
//            data["album"] = json["album"]

//            for (key, value) in dictionary {
//                print(key)
//                print(value)
//            }
//            
//            
////            let
//            let newChild = child.map({
//                if $0 != "album" || $0 != "artist"
//            })
//            
            let artist = Artist(data)
        }
        let flattedChild = json.map({ (key: String, value: Any) -> [String: Any] in
            print("key: \(key)")
            print("value: \(value)")
            return [key: value]
        })

        print("flatted: \(flattedChild)")
        print("\n\n")
    }

    func search(for name: String) {
        let netEngine = NetworkEngine()
        // Check if the data are already on my cache
        if let jsonInfoForName = netEngine.getToCache(from: "\(_cacheKeyPatern)\(name)") as? [String: Any] {
            populate(jsonInfoForName)
        } else {
            // Get my data on server
            let params: [String: Any] = ["id": name]
            let api = APIKeyEndPoint(.searchArtist)
            netEngine.getRessource(for: api, with: params, complete: { (result: NetworkEngineResult) in
                guard let responseData = result.success, let data = responseData as? [String: Any] else {
                    print("Error! \(result.error)")
                    return
                }
                // Check if I have json on my data
                if let json = data["json"] as? [String: Any] {
                    DispatchQueue.main.async {
                        self.populate(json)
                    }
                }
            })
        }

    }
/*
    func getDictFromArrayOfKeyValues(data: [[String: Any]]) -> [String: Any] {
        let parsedData = data.map({ (value: [String: Any]) -> [String: Any] in
            var d = [String: Any]()
            for (key, val) in value {
                print("key: \(key); value: \(value)")
//                d.append([key: val])
            }
            return d
//            return [value[0]: value[1]]
        })
        return [String: Any]()
//        return parsedData
    }

    func poplateData(in data: inout [String: Any], with json: [String: Any]) {
         for node in json {
            data[node.key] = node.value
        }
    }
*/
    // MARK: - Private methods

    // MARK: - Delegates methods

}
