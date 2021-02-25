//
//  ArtistDetailViewController.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import UIKit

class ArtistDetailViewController: UIViewController {

    var viewModel: ArtistDetailViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
    }
}
