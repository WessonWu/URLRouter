import Foundation

public protocol URLRouterPluginType {
    func shouldOpenURL(_ url: URLConvertible, context: URLRouter.Context) -> Bool
    func willOpenURL(_ url: URLConvertible, context: URLRouter.Context)
    func didOpenURL(_ url: URLConvertible, context: URLRouter.Context)
}

public extension URLRouterPluginType {
    func shouldOpenURL(_ url: URLConvertible, context: URLRouter.Context) -> Bool {
        return true
    }
    func willOpenURL(_ url: URLConvertible, context: URLRouter.Context) {}
    func didOpenURL(_ url: URLConvertible, context: URLRouter.Context) {}
}
