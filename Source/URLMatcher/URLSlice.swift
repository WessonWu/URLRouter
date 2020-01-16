import Foundation

public enum URLSlice: Equatable, Hashable {
    case scheme(String)
    case authority(String) // <user>:<password>@<host>:<port>
    case path(String)
    
    public var rawValue: String {
        switch self {
        case let .scheme(scheme):
            return scheme
        case let .authority(authority):
            return authority
        case let .path(path):
            return path
        }
    }
}

// MARK: - Variable & Wildcard
public extension URLSlice {
    static let VarCharacter = "<*>"
    static let WildCharacter = "*"
    
    static var schemeWildcard: URLSlice {
        return .scheme(WildCharacter)
    }
    
    static var authorityWildcard: URLSlice {
        return .authority(WildCharacter)
    }
    
    static var pathWildcard: URLSlice {
        return .path(WildCharacter)
    }
    
    static var pathVariable: URLSlice {
        return .path(VarCharacter)
    }
}

public typealias URLSlicePattern = URLSlice


extension URLComponents {
    var paths: [String] {
        return path.split(separator: "/")
            .filter { !$0.isEmpty }
            .map { String($0) }
    }
}
