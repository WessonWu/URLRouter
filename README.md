# URLRouter


```swift
struct Player: URLValueCompatible {
    let firstName: String
    let lastName: String
    
    init?(_ rawValue: String) {
        let parts = rawValue.split(separator: " ")
            .map { String($0) }
        guard parts.count == 2 else {
            return nil
        }
        
        self.init(firstName: parts[0], lastName: parts[1])
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

enum URLRouterMap {
    static func initialize(router: URLRouterType) {
        router.register("router://user/<username:string>") { router, context -> UIViewController? in
            guard let username = context.string(forKey: "username") else { return nil }
            return UserViewController(router: router, username: username)
        }
        router.register("http://*", self.webViewControllerFactory)
        router.register("https://*", self.webViewControllerFactory)
        
        router.register("router://alert", self.alert())
        router.register("*://*") { (_, _) -> Bool in
            // No router match, do analytics or fallback function here
            print("[URLRouter] URLRouterMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
        
        router.register("router://parse/buildIn/<username:string>?age=<int>&height=<double>") { (_, ctx) -> Bool in
            let username = ctx.string(forKey: "username", default: "nil")
            let age = ctx.int(forKey: "age",  default: 0)
            let height = ctx.double(forKey: "height", default: 0)
            print("[URLRouter] handle: \(ctx.pattern), username: \(username), age: \(age), height: \(height) ")
            return true
        }
        
        
        URLMatcher.customValueTypes["player"] = Player.self
        router.register("router://parse/custom?player=<player>") { (_, ctx) -> Bool in
            guard let player: Player = ctx.value(forKey: "player") else {
                return false
            }
            print("[URLRouter] handle: \(ctx.pattern), \(player)")
            return true
        }
    }
    
    private static func webViewControllerFactory(_ router: URLRouterType, _ context: URLRouterContext) -> UIViewController? {
        guard let url = try? context.url.asURL() else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func alert() -> URLOpenHandlerFactory {
        return { router, context in
            guard let title = context.string(forKey: "title") else { return false }
            let message = context.string(forKey: "message")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            router.present(alertController)
            return true
        }
    }
}

```
