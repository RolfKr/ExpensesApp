//
//  SceneDelegate.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 16/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication
import CloudKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, NSFetchedResultsControllerDelegate {
    
    let defaults = UserDefaults.standard
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var window: UIWindow?
    var database = CKContainer(identifier: "iCloud.ExpensesApp").privateCloudDatabase
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        queryDatabase()
        FetchRequest.loadCategories()
        FetchRequest.loadItems()
        FetchRequest.loadSettings()
        
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
            
        self.window?.rootViewController = checkForSecurity()
        self.window?.makeKeyAndVisible()
    }
    
    private func checkForSecurity() -> UIViewController {
        
        if let checkForSecurity = defaults.value(forKey: "useSecurity") as? Bool {
            if checkForSecurity {
                let introViewController = mainStoryboard.instantiateViewController(identifier: "LaunchVC") as! LaunchViewController
                return introViewController
            } else {
            let tabbarController = mainStoryboard.instantiateViewController(identifier: "TabBar") as! UITabBarController
                return tabbarController
            }
        }
        
        let introViewController = mainStoryboard.instantiateViewController(identifier: "IntroVC")
        return introViewController
    }
    
    private func queryDatabase() {
        let query = CKQuery(recordType: "CD_Category", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {return}
            print(records.count)
            if records.count > 0 {
                print("Got data")
            } else {
                print("Need data")
                Preload.preloadData()
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

