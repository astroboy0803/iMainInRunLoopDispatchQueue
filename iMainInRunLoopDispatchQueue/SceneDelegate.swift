/// SceneDelegate
///
/// Created by TWINB00776283 on 2023/7/14.
/// Copyright © 2023 Cathay United Bank. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = .init(windowScene: windowScene)
        window?.rootViewController = DisplayImageViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) { }

    func sceneDidBecomeActive(_: UIScene) { }

    func sceneWillResignActive(_: UIScene) { }

    func sceneWillEnterForeground(_: UIScene) { }

    func sceneDidEnterBackground(_: UIScene) { }
}
