import Foundation

// - Example: myapp://module/user/<username:string>?age=<int>&male=<bool>
// match: myapp://module/user/xiaoming?age=23&male=true
// parameters: ["username": "xiaoming", "age": 23, "male": true]

public typealias URLRouterError = URLMatchError

public final class URLRouter {
    public typealias OpenURLHandler = (Context) -> Bool
    
    public typealias Completion = (Context) -> Void
    public typealias Handler = () -> Bool
    public final class Context {
        public let url: URLConvertible
        public let pattern: String
        public let parameters: [AnyHashable: Any]
        public let userInfo: Any?
        public let completion: Completion?
        
        public init(url: URLConvertible, pattern: String, parameters: [AnyHashable: Any], userInfo: Any? = nil, completion: Completion? = nil) {
            self.url = url
            self.pattern = pattern
            self.parameters = parameters
            self.userInfo = userInfo
            self.completion = completion
        }
    }
    
    // default Router
    public static let `default` = URLRouter()
    // MARK: - Init
    public init() {}
    // MARK: - private Attrs
    private let matcher = URLMatcher()
    @SerialAccess(value: [:]) private var openURLHandlers: [AnyHashable: OpenURLHandler]
}

// MARK: - Register & Unregister
public extension URLRouter {
    @discardableResult
    func register(_ pattern: URLConvertible, handler: @escaping OpenURLHandler) -> Result<String, URLRouterError> {
        let key = pattern.absoluteString
        let result = matcher.register(pattern: pattern, tag: key)
        if case .success = result {
            openURLHandlers[key] = handler
        }
        return result
    }
    
    @discardableResult
    func unregister(_ pattern: URLConvertible) -> Bool {
        if let key = matcher.unregister(pattern: pattern) {
            openURLHandlers.removeValue(forKey: key)
            return true
        }
        return false
    }
}

// MARK: - canOpen & open
public extension URLRouter {
    func canOpen(_ url: URLConvertible, exactly: Bool = false) -> Bool {
        return matcher.canMatch(url, exactly: exactly)
    }
    
    @discardableResult
    func open(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, completion: Completion? = nil) -> Bool {
        guard let handler = self.handler(for: url, parameters: parameters, userInfo: userInfo, completion: completion) else {
            return false
        }
        return handler()
    }
    
    func handler(for url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, completion: Completion? = nil) -> Handler? {
        guard let result = matcher.match(url),
            let handler = openURLHandlers[result.tag] else {
            return nil
        }
        
        var origin = result.parameters
        if let custom = parameters {
            origin.merge(custom, uniquingKeysWith: {_, v2 in v2 })
        }
        let context = Context(url: url, pattern: result.tag, parameters: origin, userInfo: userInfo, completion: completion)
        return { handler(context) }
    }
}

public extension URLRouter.Context {
    @inlinable
    subscript<T>(forKey key: AnyHashable) -> T? {
        return parameters[key] as? T
    }
    
    @inlinable
    subscript<T>(forKey key: AnyHashable, default value: T) -> T {
        return self[forKey: key] ?? value
    }
    
    @inlinable
    func value<T>(forKey key: AnyHashable) -> T? {
        return self[forKey: key]
    }
    
    @inlinable
    func value<T>(forKey key: AnyHashable, default value: T) -> T {
        return self[forKey: key, default: value]
    }
    
    @inlinable
    func int(forKey key: AnyHashable, default value: Int = 0) -> Int {
        return self[forKey: key, default: value]
    }
    
    @inlinable
    func string(for key: AnyHashable, default value: String = "") -> String {
        return self[forKey: key, default: value]
    }
    
    @inlinable
    func double(for key: AnyHashable, default value: Double = 0) -> Double {
        return self[forKey: key, default: value]
    }
    
    @inlinable
    func float(for key: AnyHashable, default value: Float = 0) -> Float {
        return self[forKey: key, default: value]
    }
    
    @inlinable
    func bool(for key: AnyHashable, default value: Bool = false) -> Bool {
        return self[forKey: key, default: value]
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
