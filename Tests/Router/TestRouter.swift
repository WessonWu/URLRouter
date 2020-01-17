import XCTest
import URLRouter

class TestRouter: XCTestCase {
    
    var router: URLRouter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.router = URLRouter()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct CompletionInfo {
        let completion: ((URLRouterContext) -> Void)?
    }
    
    func register(_ url: URLConvertible) {
        router.register(url) { (context) -> Bool in
            guard let info = context.userInfo as? CompletionInfo else {
                return false
            }
            
            info.completion?(context)
            return true
        }
    }
    
    func open(_ url: URLConvertible, parameters: [AnyHashable: Any] = [:], completion: ((URLRouterContext) -> Void)? = nil) {
        router.open(url, parameters: parameters, userInfo: CompletionInfo(completion: completion))
    }

    func testNormal() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        register("myapp://host/user/<username: string>")
        open("myapp://host/user/kobe") { (context) in
            XCTAssertEqual(context.string(forKey: "username"), "kobe")
        }
        open("myapp://host/user/tank", parameters: ["username": "james"]) { (context) in
            XCTAssertEqual(context.string(forKey: "username"), "james")
        }
        
        open("myapp://host/user/kobe") { (context) in
            XCTAssertEqual(context.string(forKey: "username"), "kobe")
        }
        
        XCTAssertFalse(router.canOpen("myapp://host/user"))
        
        // 通配符
        register("https://*")
        register("*://*")
        open("https://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.pattern, "https://*")
        }
        
        open("unknown://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.pattern, "*://*")
        }
    }
    
    func testUnregister() {
        register("https://*")
        
        XCTAssertTrue(router.canOpen("https://www.baidu.com/path1"))
        XCTAssertFalse(router.canOpen("https://www.baidu.com/path1", exactly: true))
        
        XCTAssertTrue(router.unregister("https://*"))
        XCTAssertFalse(router.canOpen("https://www.baidu.com/path1"))
    }
}
