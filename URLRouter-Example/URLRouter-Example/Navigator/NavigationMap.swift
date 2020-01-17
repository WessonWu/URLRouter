//
//  NavigationMap.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import SafariServices
import UIKit

import URLRouter

struct CompletionInfo {
    let completion: ((URLRouterContext) -> Void)?
}

enum NavigationMap {
    static func initialize(navigator: URLRouterType) {
        navigator.register("navigator://user/<username:string>") { context -> UIViewController? in
            guard let username = context.string(forKey: "username") else { return nil }
            return UserViewController(navigator: navigator, username: username)
        }
        navigator.register("http://*", factory: self.webViewControllerFactory)
        navigator.register("https://*", factory: self.webViewControllerFactory)
        
        navigator.register("navigator://alert", factory: self.alert(navigator: navigator))
        navigator.register("navigator://*") { context -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
    }
    
    private static func webViewControllerFactory(context: URLRouterContext) -> UIViewController? {
        guard let url = try? context.url.asURL() else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func alert(navigator: URLRouterType) -> URLOpenHandlerFactory {
        return { context in
            guard let title = context.string(forKey: "title") else { return false }
            let message = context.string(forKey: "message")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
}
