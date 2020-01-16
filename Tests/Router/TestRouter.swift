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

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        router.register("myapp://host/user/<username: string>") { (context) -> Bool in
            context.completion?(context)
            return true
        }
        
        router.open("myapp://host/user/kobe") { (context) in
            XCTAssertEqual(context.string(for: "username"), "kobe")
        }
        router.open("myapp://host/user/tank", parameters: ["username": "james"]) { (context) in
            XCTAssertEqual(context.string(for: "username"), "james")
        }
        
        router.open("myapp://host/user/kobe", userInfo: ["hello": "world"]) { (context) in
            XCTAssertEqual(context.string(for: "username"), "kobe")
            XCTAssertEqual(context.userInfo?["hello"] as? String, "world")
        }
        
        XCTAssertFalse(router.canOpen("myapp://host/user"))
        
        // 通配符
        router.register("https://*") { (context) -> Bool in
            context.completion?(context)
            return true
        }
        
        router.register("*://*") { (context) -> Bool in
            context.completion?(context)
            return true
        }
        
        router.open("https://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.url.absoluteString, "https://www.example.com/user/host")
        }
        
        router.open("unknown://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.url.absoluteString, "unknown://www.example.com/user/host")
        }
    }
}
