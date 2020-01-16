import Foundation

// - Example: myapp://module/user/<username:string>?age=<int>&male=<bool>
// match: myapp://module/user/xiaoming?age=23&male=true
// parameters: ["username": "xiaoming", "age": 23, "male": true]

public typealias URLRouterError = URLMatchError

public final class URLRouter {
    public typealias OpenURLHandler = (Context) -> Bool
    
    public typealias Handler = () -> Bool
    public final class Context {
        public let url: URLConvertible
        public let pattern: String
        public let parameters: [AnyHashable: Any]
        public let userInfo: Any?
        
        public init(url: URLConvertible, pattern: String, parameters: [AnyHashable: Any], userInfo: Any? = nil) {
            self.url = url
            self.pattern = pattern
            self.parameters = parameters
            self.userInfo = userInfo
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
    func open(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> Bool {
        guard let handler = self.handler(for: url, parameters: parameters, userInfo: userInfo) else {
            return false
        }
        return handler()
    }
    
    func handler(for url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> Handler? {
        guard let result = matcher.match(url),
            let handler = openURLHandlers[result.tag] else {
            return nil
        }
        
        var origin = result.parameters
        if let custom = parameters {
            origin.merge(custom, uniquingKeysWith: {_, v2 in v2 })
        }
        let context = Context(url: url, pattern: result.tag, parameters: origin, userInfo: userInfo)
        return { handler(context) }
    }
}

public extension URLRouter.Context {
    @inlinable
    func value<T>(forKey key: AnyHashable) -> T? {
        return parameters[key] as? T
    }
    
    @inlinable
    func value<T>(forKey key: AnyHashable, default value: T) -> T {
        return parameters[key] as? T ?? value
    }
    
    // MARK: - Optional Value
    @inlinable
    func string(forKey key: AnyHashable) -> String? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func bool(forKey key: AnyHashable) -> Bool? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int(forKey key: AnyHashable) -> Int? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int8(forKey key: AnyHashable) -> Int8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int16(forKey key: AnyHashable) -> Int16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int32(forKey key: AnyHashable) -> Int32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int64(forKey key: AnyHashable) -> Int64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint(forKey key: AnyHashable) -> UInt? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint8(forKey key: AnyHashable) -> UInt8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint16(forKey key: AnyHashable) -> UInt16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint32(forKey key: AnyHashable) -> UInt32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint64(forKey key: AnyHashable) -> UInt64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func double(forKey key: AnyHashable) -> Double? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float(forKey key: AnyHashable) -> Float? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float32(forKey key: AnyHashable) -> Float32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float64(forKey key: AnyHashable) -> Float64? {
        return self.value(forKey: key)
    }
    
    // MARK: - Exact Value
    @inlinable
    func string(forKey key: AnyHashable, default value: String) -> String {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func bool(forKey key: AnyHashable, default value: Bool) -> Bool {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int(forKey key: AnyHashable, default value: Int) -> Int {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int8(forKey key: AnyHashable, default value: Int8) -> Int8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int16(forKey key: AnyHashable, default value: Int16) -> Int16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int32(forKey key: AnyHashable, default value: Int32) -> Int32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int64(forKey key: AnyHashable, default value: Int64) -> Int64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint(forKey key: AnyHashable, default value: UInt) -> UInt {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint8(forKey key: AnyHashable, default value: UInt8) -> UInt8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint16(forKey key: AnyHashable, default value: UInt16) -> UInt16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint32(forKey key: AnyHashable, default value: UInt32) -> UInt32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint64(forKey key: AnyHashable, default value: UInt64) -> UInt64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func double(forKey key: AnyHashable, default value: Double) -> Double {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float(forKey key: AnyHashable, default value: Float) -> Float {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float32(forKey key: AnyHashable, default value: Float32) -> Float32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float64(forKey key: AnyHashable, default value: Float64) -> Float64 {
        return self.value(forKey: key, default: value)
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
