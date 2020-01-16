import Foundation

public enum URLMatchError: Swift.Error {
    // pattern parse
    case unresolvedURLVariable(String)
    case ambiguousURLVariable(String, String)
    
    // register pattern
    case ambiguousRegistration
    
    case underlying(Error)
}

extension URLMatchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unresolvedURLVariable(v1):
            return "Use of unresolved identifier '\(v1)'."
        case let .ambiguousURLVariable(v1, v2):
            return "'\(v1)' is ambiguous with '\(v2)'."
        case .ambiguousRegistration:
            return "Registration is duplicated."
        case let .underlying(error):
            return error.localizedDescription
        }
    }
}
