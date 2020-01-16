import XCTest
import URLRouter

class TestURLSlicer: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSlice() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let scheme = "https"
        let host = "www.example.com"
        let path = "/user/hello"
        var comps = URLComponents()
        
        XCTAssertEqual(URLSlicer.slice(components: comps), [])
        comps.scheme = scheme
        
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme)])
        
        comps.host = host
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme), .authority(host)])
        
        comps.path = path
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme), .authority(host), .path("user"), .path("hello")])
        
    }
    
    func testParse() {
        func testcase1(_ url: URLConvertible) {
            do {
                let context = try URLSlicer.parse(pattern: url)
                XCTAssert(context.patterns == [.scheme("https"), .authority("www.example.com"), .path("user"), .pathVariable])
                XCTAssert(context.pathVars == [URLVariable(name: "username", type: "string")])
                XCTAssert(context.queryVars == [URLVariable(name: "q1", type: "int"), URLVariable(name: "q2", type: "bool")])
            } catch {
                XCTFail("Parse Error")
            }
        }
        
        testcase1("https://www.example.com/user/<username:string>?q1=<int>&q2=<bool>")
        testcase1("https://www.example.com/user/<username: STRING>?q1=< INT>&q2=<BOOL >")
        testcase1("https://www.example.com/user/< username:string >?q1=< int >&q2=< bool >&q3=c3")
        
        
        func testcase2(_ url: URLConvertible) {
            XCTAssertThrowsError(try URLSlicer.parse(pattern: url), "error") { (error) in
                XCTAssert(error is URLRouterError)
            }
        }
        testcase2("https://www.example.com/user/<username>?q1=<int>&q2=<bool>")
        
        func testcase3(_ url: URLConvertible) {
            XCTAssertThrowsError(try URLSlicer.parse(pattern: url), "error") { (error) in
                XCTAssert(error is URLRouterError)
            }
        }
        testcase3("https://www.example.com/user/<q1:string>?q1=<int>&q2=<bool>")
        testcase3("https://www.example.com/user/<username:string>?q1=<int>&q1=<bool>")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
