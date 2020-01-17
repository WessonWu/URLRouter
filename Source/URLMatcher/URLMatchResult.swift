import Foundation

public struct URLMatchResult {
    public let tag: String
    public let matched: [URLSlicePattern]
    public let values: [String: Any]
    
    public init(tag: String, matched: [URLSlicePattern], values: [String: Any]) {
        self.tag = tag
        self.matched = matched
        self.values = values
    }
}

extension URLMatchResult: CustomStringConvertible {
    public var description: String {
        return ["tag": tag,
                "matched": URLMatcher.format(for: matched),
                "parameters": values.description].description
    }
}

extension URLMatchResult: URLValueGettable {}

public protocol URLValueGettable {
    var values: [String: Any] { get }
}

public extension URLValueGettable {
    @inlinable
    func value<T>(forKey key: String) -> T? {
        return values[key] as? T
    }
    
    @inlinable
    func value<T>(forKey key: String, default value: T) -> T {
        return values[key] as? T ?? value
    }
    
    // MARK: - Optional Value
    @inlinable
    func string(forKey key: String) -> String? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func bool(forKey key: String) -> Bool? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int(forKey key: String) -> Int? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int8(forKey key: String) -> Int8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int16(forKey key: String) -> Int16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int32(forKey key: String) -> Int32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int64(forKey key: String) -> Int64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint(forKey key: String) -> UInt? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint8(forKey key: String) -> UInt8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint16(forKey key: String) -> UInt16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint32(forKey key: String) -> UInt32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint64(forKey key: String) -> UInt64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func double(forKey key: String) -> Double? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float(forKey key: String) -> Float? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float32(forKey key: String) -> Float32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float64(forKey key: String) -> Float64? {
        return self.value(forKey: key)
    }
    
    // MARK: - Exact Value
    @inlinable
    func string(forKey key: String, default value: String) -> String {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func bool(forKey key: String, default value: Bool) -> Bool {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int(forKey key: String, default value: Int) -> Int {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int8(forKey key: String, default value: Int8) -> Int8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int16(forKey key: String, default value: Int16) -> Int16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int32(forKey key: String, default value: Int32) -> Int32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int64(forKey key: String, default value: Int64) -> Int64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint(forKey key: String, default value: UInt) -> UInt {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint8(forKey key: String, default value: UInt8) -> UInt8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint16(forKey key: String, default value: UInt16) -> UInt16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint32(forKey key: String, default value: UInt32) -> UInt32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint64(forKey key: String, default value: UInt64) -> UInt64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func double(forKey key: String, default value: Double) -> Double {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float(forKey key: String, default value: Float) -> Float {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float32(forKey key: String, default value: Float32) -> Float32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float64(forKey key: String, default value: Float64) -> Float64 {
        return self.value(forKey: key, default: value)
    }
}
