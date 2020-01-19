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

extension URLMatchResult: KeyValueCoding {
    public typealias Key = String
    public func value<Value>(forKey key: String) -> Value? {
        return values[key] as? Value
    }
}
