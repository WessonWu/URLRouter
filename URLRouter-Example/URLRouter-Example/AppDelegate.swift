//
//  AppDelegate.swift
//  URLRouter-Example
//
//  Created by wuweixin on 2020/1/16.
//  Copyright © 2020 wuweixin. All rights reserved.
//

import UIKit
import URLRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var navigator: NavigatorType?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigator = Navigator()
        
        // Initialize navigation map
        NavigationMap.initialize(navigator: navigator)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        
        let userListViewController = UserListViewController(navigator: navigator)
        window.rootViewController = UINavigationController(rootViewController: userListViewController)
        
        self.window = window
        self.navigator = navigator
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:])-> Bool {
        // Try presenting the URL first
        if self.navigator?.present(url, wrap: UINavigationController.self) != nil {
            print("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if self.navigator?.open(url) == true {
            print("[Navigator] open: \(url)")
            return true
        }
        
        return false
    }
}

