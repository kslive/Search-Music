//
//  SearchProvider.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import Moya

enum SearchProvider: TargetType {
    case artistList(searchString: String, limit: Int, offset: Int) 
    
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com/")!
    }
    
    var path: String {
        switch self {
        case .artistList:
            return "search"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .artistList(searchString: let searchString, limit: let limit, offset: let offset):
            return .requestParameters(parameters: ["term": searchString,
                                                   "entity": "musicArtist",
                                                   "limit": limit,
                                                   "offset": offset], encoding: URLEncoding())
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
