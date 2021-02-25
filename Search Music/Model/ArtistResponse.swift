//
//  ArtistResponse.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import Foundation

struct ArtistResponse: Decodable {
    let resultCount: Int
    let results: [Artist]
}
