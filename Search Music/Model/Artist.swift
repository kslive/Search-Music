//
//  Artist.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import Foundation

struct Artist: Decodable {
    let wrapperType: String
    let artistName: String
    let artistId: Int
}
