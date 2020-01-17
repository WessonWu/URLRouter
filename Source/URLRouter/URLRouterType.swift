#if os(iOS) || os(tvOS)
import UIKit

public typealias ViewControllerFactory = (URLRouterContext) -> UIViewController?
public typealias URLOpenHandlerFactory = (URLRouterContext) -> Bool
public typealias URLOpenHandler = () -> Bool

public typealias URLPattern = URLConvertible
public typealias URLRouterError = URLMatchError

public protocol URLRouterType {
    var delegate: URLRouterDelegate? { get set }
    
    /// Registers a view controller factory to the URL pattern.
    @discardableResult
    func register(_ pattern: URLPattern, factory: @escaping ViewControllerFactory) -> Result<Void, URLRouterError>
    
    /// Registers an URL open handler to the URL pattern.
    @discardableResult
    func register(_ pattern: URLPattern, factory: @escaping URLOpenHandlerFactory) -> Result<Void, URLRouterError>
    /// Returns a matching view controller from the specified URL.
    ///
    /// - parameter url: An URL to find view controllers.
    ///
    /// - returns: A match view controller or `nil` if not matched.
    func viewController(for url: URLConvertible, parameters: [AnyHashable: Any]?, userInfo: Any?) -> UIViewController?
    
    /// Returns a matching URL handler from the specified URL.
    ///
    /// - parameter url: An URL to find url handlers.
    ///
    /// - returns: A matching handler factory or `nil` if not matched.
    func handler(for url: URLConvertible, parameters: [AnyHashable: Any]?, userInfo: Any?) -> URLOpenHandler?
    
    /// Pushes a matching view controller to the navigation controller stack.
    ///
    /// - note: It is not a good idea to use this method directly because this method requires all
    ///         parameters. This method eventually gets called when pushing a view controller with
    ///         an URL, so it's recommended to implement this method only for mocking.
    @discardableResult
    func pushURL(_ url: URLConvertible, parameters: [AnyHashable: Any]?, userInfo: Any?, from: UINavigationControllerType?, animated: Bool) -> UIViewController?
    
    /// Pushes the view controller to the navigation controller stack.
    ///
    /// - note: It is not a good idea to use this method directly because this method requires all
    ///         parameters. This method eventually gets called when pushing a view controller, so
    ///         it's recommended to implement this method only for mocking.
    @discardableResult
    func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController?
    
    /// Presents a matching view controller.
    ///
    /// - note: It is not a good idea to use this method directly because this method requires all
    ///         parameters. This method eventually gets called when presenting a view controller with
    ///         an URL, so it's recommended to implement this method only for mocking.
    @discardableResult
    func presentURL(_ url: URLConvertible, parameters: [AnyHashable: Any]?, userInfo: Any?, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController?
    
    /// Presents the view controller.
    ///
    /// - note: It is not a good idea to use this method directly because this method requires all
    ///         parameters. This method eventually gets called when presenting a view controller, so
    ///         it's recommended to implement this method only for mocking.
    @discardableResult
    func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController?
    
    /// Executes an URL open handler.
    ///
    /// - note: It is not a good idea to use this method directly because this method requires all
    ///         parameters. This method eventually gets called when opening an url, so it's
    ///         recommended to implement this method only for mocking.
    @discardableResult
    func handleURL(_ url: URLConvertible, parameters: [AnyHashable: Any]?, userInfo: Any?) -> Bool
}


// MARK: - Protocol Requirements

public extension URLRouterType {
    func viewController(for url: URLConvertible) -> UIViewController? {
        return self.viewController(for: url, parameters: [:], userInfo: nil)
    }
    
    func handler(for url: URLConvertible) -> URLOpenHandler? {
        return self.handler(for: url, parameters: [:], userInfo: nil)
    }
    
    @discardableResult
    func pushURL(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        guard let viewController = self.viewController(for: url, parameters: parameters, userInfo: userInfo) else { return nil }
        return self.pushViewController(viewController, from: from, animated: animated)
    }
    
    @discardableResult
    func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
        guard (viewController is UINavigationController) == false else { return nil }
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else { return nil }
        guard self.delegate?.shouldPush(viewController: viewController, from: navigationController) != false else { return nil }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    @discardableResult
    func presentURL(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        guard let viewController = self.viewController(for: url, parameters: parameters, userInfo: userInfo) else { return nil }
        return self.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.topMost else { return nil }
        
        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
        } else {
            viewControllerToPresent = viewController
        }
        
        guard self.delegate?.shouldPresent(viewController: viewController, from: fromViewController) != false else { return nil }
        fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        return viewController
    }
    
    @discardableResult
    func handleURL(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> Bool {
        guard let handler = self.handler(for: url, parameters: parameters, userInfo: userInfo) else { return false }
        return handler()
    }
}


// MARK: - Syntactic Sugars for Optional Parameters

public extension URLRouterType {
    @discardableResult
    func push(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return self.pushURL(url, parameters: parameters, userInfo: userInfo, from: from, animated: animated)
    }
    
    @discardableResult
    func push(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return self.pushViewController(viewController, from: from, animated: animated)
    }
    
    @discardableResult
    func present(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return self.presentURL(url, parameters: parameters, userInfo: userInfo, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    func present(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return self.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    func handle(_ url: URLConvertible, parameters: [AnyHashable: Any]? = nil, userInfo: Any? = nil) -> Bool {
        return self.handleURL(url, parameters: parameters, userInfo: userInfo)
    }
}
#endif
