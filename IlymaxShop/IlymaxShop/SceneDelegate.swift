//
//  SceneDelegate.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator()
        window.rootViewController = appCoordinator.start()
        window.makeKeyAndVisible()
        window.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.window = window
    }
}

