//
//  SearchService.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import Moya
import RxSwift

protocol SearchServiceProtocol {
    func artistList(searchString: String, limit: Int, offset: Int) -> Observable<ArtistResponse>
}

class SearchService: SearchServiceProtocol {
    
    private let provider = MoyaProvider<SearchProvider>()
    private let queue = DispatchQueue.init(label: "ru.itunes.search")
    
    func artistList(searchString: String, limit: Int, offset: Int) -> Observable<ArtistResponse> {
        let token: SearchProvider = .artistList(searchString: searchString, limit: limit, offset: offset) 
        return provider.rx
            .request(token, callbackQueue: queue)
            .map(ArtistResponse.self)
            .asObservable()
    }
}

