//
//  ArtistDetailViewModel.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import Foundation

protocol ArtistDetailViewModelProtocol {
    var title: String { get }
}

class ArtistDetailViewModel: ArtistDetailViewModelProtocol {
    private let router: ArtistDetailRouter
    private let service: SearchServiceProtocol
    private let artist: Artist
    
    var title: String
    
    init(router: ArtistDetailRouter, artist: Artist, service: SearchServiceProtocol = SearchService() ) {
        self.router = router
        self.service = service
        self.artist = artist
        
        self.title = artist.artistName
    }
}
