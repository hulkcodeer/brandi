//
//  SceneDelegate.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let naviViewcon = self.window?.rootViewController as! UINavigationController
        let viewcon = naviViewcon.viewControllers.first as! MainViewController
        viewcon.reactor = MainViewReactor(provider: RestApi())
    }
}

