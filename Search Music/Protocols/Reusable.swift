//
//  Reusable.swift
//  Search Music
//
//  Created by Eugene Kiselev on 25.02.2021.
//

import UIKit

protocol Reusable {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
