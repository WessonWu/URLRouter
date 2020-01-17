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
    private var router: URLRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let router = URLRouter()
//        let router = URLRouter.default
        
        // Initialize router map
        URLRouterMap.initialize(router: router)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        let userListViewController = UserListViewController(router: router)
        window.rootViewController = UINavigationController(rootViewController: userListViewController)
        
        self.window = window
        self.router = router
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:])-> Bool {
        if router?.open(url) == true {
            return true
        }
        
//        if router?.handle(url) == true {
//            return true
//        }
//
//        if router?.present(url) != nil {
//            return true
//        }
        
        return false
    }
}

