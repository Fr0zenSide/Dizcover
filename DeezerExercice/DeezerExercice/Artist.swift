//
//  Artist.swift
//  DeezerExercice
//
//  Created by Jeoffrey Thirot on 14/01/2018.
//  Copyright © 2018 Deezer. All rights reserved.
//

import Foundation


struct Artist {
    var id: String
    var name: String
    var photo: String?
    var rank: Int?
    var albums: [Album]?
}
