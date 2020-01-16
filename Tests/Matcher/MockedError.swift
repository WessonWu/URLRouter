import Foundation
import URLRouter

enum MockedURLMatchError: Int {
    case unresolvedURLVariable
    case ambiguousURLVariable
    case ambiguousRegistration
    case underlying
}


extension URLMatchError {
    func asMockedError() -> MockedURLMatchError {
        switch self {
        case .unresolvedURLVariable:
            return .unresolvedURLVariable
        case .ambiguousURLVariable:
            return .ambiguousURLVariable
        case .ambiguousRegistration:
            return .ambiguousRegistration
        case .underlying:
            return .underlying
        }
    }
}
