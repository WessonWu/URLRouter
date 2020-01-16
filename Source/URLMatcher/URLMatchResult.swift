import Foundation

public struct URLMatchResult {
    public let tag: String
    public let matched: [URLSlicePattern]
    public let parameters: [AnyHashable: Any]
    
    public init(tag: String, matched: [URLSlicePattern], parameters: [AnyHashable: Any]) {
        self.tag = tag
        self.matched = matched
        self.parameters = parameters
    }
}

extension URLMatchResult: CustomStringConvertible {
    public var description: String {
        return ["tag": tag,
                "matched": URLMatcher.format(for: matched),
                "parameters": parameters.description].description
    }
}
