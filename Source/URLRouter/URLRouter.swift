#if os(iOS) || os(tvOS)
import Foundation
// - Example: myapp://module/user/<username:string>?age=<int>&male=<bool>
// match: myapp://module/user/xiaoming?age=23&male=true
// parameters: ["username": "xiaoming", "age": 23, "male": true]

public final class URLRouter: URLRouterType {
    // default Router
    public static let `default` = URLRouter()
    // MARK: - Init
    public init() {}
    // MARK: - URLRouterType
    public var delegate: URLRouterDelegate?
    
    @discardableResult
    public func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) -> Result<Void, URLRouterError> {
        return register(pattern, factory, to: &self.viewControllerFactories)
    }
    
    @discardableResult
    public func register(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) -> Result<Void, URLRouterError> {
        return register(pattern, factory, to: &self.handlerFactories)
    }
    
    public func viewController(for url: URLConvertible, parameters: [AnyHashable : Any]? = nil, userInfo: Any? = nil) -> UIViewController? {
        guard let context = match(url, parameters: parameters, userInfo: userInfo) else {
            return nil
        }
        return viewController(for: context)
    }
    
    public func handler(for url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> URLOpenHandler? {
        guard let context = match(url, parameters: parameters, userInfo: userInfo) else {
            return nil
        }
        return handler(for: context)
    }
    
    // MARK: - private Attrs
    private let matcher = URLMatcher()
    
    @SerialAccess(value: [:]) private var viewControllerFactories: [AnyHashable: ViewControllerFactory]
    @SerialAccess(value: [:]) private var handlerFactories: [AnyHashable: URLOpenHandlerFactory]
}

// MARK: - Unregister & canOpen & open
public extension URLRouter {
    @discardableResult
    func unregister(_ pattern: URLConvertible) -> Bool {
        if let key = matcher.unregister(pattern: pattern) {
            viewControllerFactories.removeValue(forKey: key)
            handlerFactories.removeValue(forKey: key)
            return true
        }
        return false
    }
    
    func canOpen(_ url: URLConvertible, exactly: Bool = false) -> Bool {
        return matcher.canMatch(url, exactly: exactly)
    }
    
    @discardableResult
    func open(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> Bool {
        guard let context = match(url, parameters: parameters, userInfo: userInfo) else {
            return false
        }
        if let handler = handler(for: context) {
            return handler()
        }
        guard let vc = viewController(for: context) else {
            return false
        }
        if push(vc) != nil {
            return true
        }
        return present(vc) != nil
    }
}

// MARK: - Privates
private extension URLRouter {
    func viewController(for context: URLRouterContext) -> UIViewController? {
        return self.viewControllerFactories[context.pattern]?(self, context)
    }
    
    func handler(for context: URLRouterContext) -> URLOpenHandler? {
        if let factory = handlerFactories[context.pattern] {
            return { factory(self, context) }
        }
        return nil
    }
    
    func match(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any?) -> URLRouterContext? {
        guard let result = matcher.match(url) else {
            return nil
        }
        
        var finalValues = result.parameters
        if let customValues = parameters {
            finalValues.merge(customValues, uniquingKeysWith: {_, v2 in v2 })
        }
        return URLRouterContext(url: url, pattern: result.tag, parameters: finalValues, userInfo: userInfo)
    }
    
    func register<T>(_ pattern: URLPattern, _ factory: T, to factories: inout [AnyHashable: T]) -> Result<Void, URLRouterError> {
        let key = pattern.absoluteString
        switch matcher.register(pattern: pattern, tag: key) {
        case .success:
            factories[key] = factory
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }
}

fileprivate extension URLRouter {
    static let serialQueue = DispatchQueue.init(label: "cn.wessonwu.URLRouter.SerialAccessQueue") // Thread safe
}

@propertyWrapper
final class SerialAccess<T> {
    var value: T
    var wrappedValue: T {
        get {
            return URLRouter.serialQueue.sync {
                return self.value
            }
        }
        set {
            URLRouter.serialQueue.async {
                self.value = newValue
            }
        }
    }
    init(value: T) {
        self.value = value
    }
}

#endif
