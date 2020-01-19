import Foundation

public struct URLRouterContext {
    public let url: URLConvertible
    public let pattern: URLPattern
    public let values: [String: Any]
    public let userInfo: Any?
    
    public init(url: URLConvertible, pattern: URLPattern, values: [String: Any], userInfo: Any? = nil) {
        self.url = url
        self.pattern = pattern
        self.values = values
        self.userInfo = userInfo
    }
}

extension URLRouterContext: KeyValueCoding {
    public typealias Key = String
    
    public func value<Value>(forKey key: String) -> Value? {
        return values[key] as? Value
    }
}
