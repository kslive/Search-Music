//
//  ArtistDetailRouter.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import UIKit

class BaseRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

class ArtistDetailRouter: BaseRouter {
    
}
