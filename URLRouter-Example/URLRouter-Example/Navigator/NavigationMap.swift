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
    let completion: ((URLRouter.Context) -> Void)?
}

enum NavigationMap {
    static func initialize(navigator: NavigatorType) {
        #if USE_ROUTER
        let router = URLRouter.default
        router.register("navigator://user/<username:string>") { (context) -> Bool in
            guard let username = context.string(forKey: "username"),
                let nav = UIViewController.topMost?.navigationController else {
                    return false
            }
            nav.pushViewController(
                UserViewController(username: username),
                animated: true)
            if let completion = (context.userInfo as? CompletionInfo)?.completion {
                completion(context)
            }
            return true
        }
        router.register("http://*", handler: self.webViewControllerFactory)
        router.register("https://*", handler: self.webViewControllerFactory)
        
        router.register("navigator://alert", handler: self.alert())
        router.register("navigator://*") { (context) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Router] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
        #else
        navigator.register("navigator://user/<username:string>") { url, values, context in
            guard let username = values["username"] as? String else { return nil }
            return UserViewController(navigator: navigator, username: username)
        }
        navigator.register("http://*", self.webViewControllerFactory)
        navigator.register("https://*", self.webViewControllerFactory)
        
        navigator.handle("navigator://alert", self.alert(navigator: navigator))
        navigator.handle("navigator://*") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
        #endif
    }
    
    #if USE_ROUTER
    private static func webViewControllerFactory(_ context: URLRouter.Context) -> Bool {
        guard let url = try? context.url.asURL(), let topMost = UIViewController.topMost else { return false }
        var completion: (() -> Void)? = nil
        if let handler = (context.userInfo as? CompletionInfo)?.completion {
            completion = { handler(context) }
        }
        topMost.present(SFSafariViewController(url: url), animated: true, completion: completion)
        return true
    }
    #else
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [AnyHashable: Any],
        context: Any?
    ) -> UIViewController? {
        guard let url = try? url.asURL() else { return nil }
        return SFSafariViewController(url: url)
    }
    #endif
    
    #if USE_ROUTER
    private static func alert() -> URLRouter.OpenURLHandler {
        return { context in
            guard let title = context.string(forKey: "title"),
                let topMost = UIViewController.topMost else { return false }
            let message = context.string(forKey: "message")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            var handler: (() -> Void)? = nil
            if let completion = (context.userInfo as? CompletionInfo)?.completion {
                handler = { completion(context) }
            }
            topMost.present(alertController, animated: true, completion: handler)
            return true
        }
    }
    #else
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = values["title"] as? String else { return false }
            let message = values["message"] as? String
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    #endif
}
