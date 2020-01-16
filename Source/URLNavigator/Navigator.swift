#if os(iOS) || os(tvOS)
import UIKit

#if !COCOAPODS
import URLMatcher
#endif

open class Navigator: NavigatorType {
  public let matcher = URLMatcher()
  open weak var delegate: NavigatorDelegate?

  private var viewControllerFactories = [String: ViewControllerFactory]()
  private var handlerFactories = [String: URLOpenHandlerFactory]()

  public init() {
    // ⛵ I'm a Navigator!
  }

  open func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
    let result = matcher.register(pattern: pattern)
    if case let .success(tag) = result {
        viewControllerFactories[tag] = factory
    }
  }

  open func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
    let result = matcher.register(pattern: pattern)
    if case let .success(tag) = result {
        handlerFactories[tag] = factory
    }
  }

  open func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
    guard let match = self.matcher.match(url) else { return nil }
    guard let factory = self.viewControllerFactories[match.tag] else { return nil }
    return factory(url, match.parameters, context)
  }

  open func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
    guard let match = self.matcher.match(url) else { return nil }
    guard let handler = self.handlerFactories[match.tag] else { return nil }
    return { handler(url, match.parameters, context) }
  }
}
#endif
