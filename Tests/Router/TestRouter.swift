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

    func testNormal() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        router.register("myapp://host/user/<username: string>") { (context, completion) -> Bool in
            completion?(context)
            return true
        }
        
        router.open("myapp://host/user/kobe") { (context) in
            XCTAssertEqual(context.string(for: "username"), "kobe")
        }
        router.open("myapp://host/user/tank", parameters: ["username": "james"]) { (context) in
            XCTAssertEqual(context.string(for: "username"), "james")
        }
        
        router.open("myapp://host/user/kobe", userInfo: "hello") { (context) in
            XCTAssertEqual(context.string(for: "username"), "kobe")
            XCTAssertEqual(context.userInfo as? String, "hello")
        }
        
        XCTAssertFalse(router.canOpen("myapp://host/user"))
        
        // 通配符
        router.register("https://*") { (context, completion) -> Bool in
            completion?(context)
            return true
        }
        
        router.register("*://*") { (context, completion) -> Bool in
            completion?(context)
            return true
        }
        
        router.open("https://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.pattern, "https://*")
        }
        
        router.open("unknown://www.example.com/user/host") { (context) in
            XCTAssertEqual(context.pattern, "*://*")
        }
    }
    
    func testUnregister() {
        router.register("https://*") { (context, completion) -> Bool in
            completion?(context)
            return true
        }
        
        XCTAssertTrue(router.canOpen("https://www.baidu.com/path1"))
        XCTAssertFalse(router.canOpen("https://www.baidu.com/path1", exactly: true))
        
        XCTAssertTrue(router.unregister("https://*"))
        XCTAssertFalse(router.canOpen("https://www.baidu.com/path1"))
    }
}
