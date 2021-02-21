//
//  SceneDelegate.swift
//  Trendz Music
//
//  Created by Girira Stephy on 18/02/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())//UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        print(url)
        let userInfo: [String: Any] = ["url": url]
        NotificationCenter.default.post(name: NSNotification.Name("RecievedAccessToken"), object: nil, userInfo: userInfo)

    }

}

