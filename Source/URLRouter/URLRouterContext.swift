import Foundation

public final class URLRouterContext {
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

public extension URLRouterContext {
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
