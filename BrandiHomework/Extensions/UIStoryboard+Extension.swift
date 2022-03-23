//
//  UIStoryboard+Extension.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseID) as? T else {
            fatalError("error: instantiateViewController")
        }
        return viewController
    }
}

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        String(describing: self)
    }
}
