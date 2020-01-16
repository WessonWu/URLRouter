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

enum NavigationMap {
  static func initialize(navigator: NavigatorType) {
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
  }

  private static func webViewControllerFactory(
    url: URLConvertible,
    values: [AnyHashable: Any],
    context: Any?
  ) -> UIViewController? {
    guard let url = try? url.asURL() else { return nil }
    return SFSafariViewController(url: url)
  }

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
}
