import Foundation

public protocol KeyValueCoding {
    associatedtype Key: Hashable
    func value<Value>(forKey key: Key) -> Value?
}

public extension KeyValueCoding {
    @inlinable
    func value<Value>(forKey key: Key, default value: Value) -> Value {
        return self.value(forKey: key) ?? value
    }
    
    @inlinable
    func value<Value>(of type: Value.Type, forKey key: Key) -> Value? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func value<Value>(of type: Value.Type, forKey key: Key, default value: Value) -> Value {
        return self.value(forKey: key) ?? value
    }
}

// MARK: - Optional values for build in types
public extension KeyValueCoding {
    @inlinable
    func string(forKey key: Key) -> String? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func bool(forKey key: Key) -> Bool? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int(forKey key: Key) -> Int? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int8(forKey key: Key) -> Int8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int16(forKey key: Key) -> Int16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int32(forKey key: Key) -> Int32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func int64(forKey key: Key) -> Int64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint(forKey key: Key) -> UInt? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint8(forKey key: Key) -> UInt8? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint16(forKey key: Key) -> UInt16? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint32(forKey key: Key) -> UInt32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func uint64(forKey key: Key) -> UInt64? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func double(forKey key: Key) -> Double? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float(forKey key: Key) -> Float? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float32(forKey key: Key) -> Float32? {
        return self.value(forKey: key)
    }
    
    @inlinable
    func float64(forKey key: Key) -> Float64? {
        return self.value(forKey: key)
    }
}

// MARK: - Exact Value for build in types
public extension KeyValueCoding {
    @inlinable
    func string(forKey key: Key, default value: String) -> String {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func bool(forKey key: Key, default value: Bool) -> Bool {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int(forKey key: Key, default value: Int) -> Int {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int8(forKey key: Key, default value: Int8) -> Int8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int16(forKey key: Key, default value: Int16) -> Int16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int32(forKey key: Key, default value: Int32) -> Int32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func int64(forKey key: Key, default value: Int64) -> Int64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint(forKey key: Key, default value: UInt) -> UInt {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint8(forKey key: Key, default value: UInt8) -> UInt8 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint16(forKey key: Key, default value: UInt16) -> UInt16 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint32(forKey key: Key, default value: UInt32) -> UInt32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func uint64(forKey key: Key, default value: UInt64) -> UInt64 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func double(forKey key: Key, default value: Double) -> Double {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float(forKey key: Key, default value: Float) -> Float {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float32(forKey key: Key, default value: Float32) -> Float32 {
        return self.value(forKey: key, default: value)
    }
    
    @inlinable
    func float64(forKey key: Key, default value: Float64) -> Float64 {
        return self.value(forKey: key, default: value)
    }
}
