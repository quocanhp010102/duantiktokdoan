//
//  SceneDelegate.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 09/04/2024.
//

import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        configInitiaViewController()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func configInitiaViewController(){
        var initiaVC:UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            initiaVC = storyboard.instantiateViewController(withIdentifier: INDENTIFIER_TABBAR)
        }else{
            initiaVC = storyboard.instantiateViewController(withIdentifier: INDENTIFIER_MAIN)
        }
        window?.rootViewController = initiaVC
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

