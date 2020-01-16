import XCTest
import URLRouter

class TestURLSlicer: XCTestCase {
    func testSliceURLComponents() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let scheme = "https"
        let host = "www.example.com"
        let path = "/user/hello"
        var comps = URLComponents()
        
        XCTAssertEqual(URLSlicer.slice(components: comps), [])
        comps.scheme = scheme
//        comps.scheme = "*" // caught "NSInvalidArgumentException", "*** +[NSURLComponents setScheme:]: invalid characters in scheme"
        // valid characters: 字母+数字组合  以字母开头 comps.scheme = "s2"
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme)])
        
        comps.host = host
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme), .authority(host)])
        
        comps.path = path
        XCTAssertEqual(URLSlicer.slice(components: comps), [.scheme(scheme), .authority(host), .path("user"), .path("hello")])
        
    }
    
    func testSliceURLConvertible() {
        XCTAssertEqual(try? URLSlicer.slice(url: "myscheme://myhost/mypath1"), [.scheme("myscheme"), .authority("myhost"), .path("mypath1")])
        XCTAssertEqual(try? URLSlicer.slice(url: "*://myhost/mypath1"), [.path("*:"), .path("myhost"), .path("mypath1")])
    }
    
    
    typealias ParseAssertion = (Result<URLPatternContext, URLMatchError>) -> Void
    func parse(_ url: URLConvertible, assertion: ParseAssertion) {
        do {
            let context = try URLSlicer.parse(pattern: url)
            assertion(.success(context))
        } catch {
            if let resolvedError = error as? URLMatchError {
                
                return assertion(.failure(resolvedError))
            }
            return assertion(.failure(.underlying(error)))
        }
    }
    
    func parseSuccess(_ assertion: @escaping (URLPatternContext) -> Void) -> ParseAssertion {
        return { result in
            switch result {
            case let .success(ctx):
                assertion(ctx)
            case .failure:
                XCTFail("Parse Failed")
            }
        }
    }
    
    func parseFailed(_ mockedError: MockedURLMatchError) -> ParseAssertion {
        return { result in
            switch result {
            case .success:
                XCTFail("Parse Success")
            case let .failure(error):
                XCTAssertEqual(error.asMockedError(), mockedError)
            }
        }
    }
    
    
    func testParse() {
        parse("https://myhost/mypath1/mypath2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.scheme("https"), .authority("myhost"), .path("mypath1"), .path("mypath2")])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        func testcase1(_ url: URLConvertible) {
            parse(url, assertion: parseSuccess({ (context) in
                XCTAssertEqual(context.patterns, [.scheme("https"), .authority("www.example.com"), .path("user"), .pathVariable])
                XCTAssertEqual(context.pathVars, [URLVariable(name: "username", type: "string")])
                XCTAssertEqual(context.queryVars, [URLVariable(name: "q1", type: "int"), URLVariable(name: "q2", type: "bool")])
            }))
        }
        
        testcase1("https://www.example.com/user/<username:string>?q1=<int>&q2=<bool>")
        testcase1("https://www.example.com/user/<username: STRING>?q1=< INT>&q2=<BOOL >")
        testcase1("https://www.example.com/user/< username:string >?q1=< int >&q2=< bool >&q3=c3")
        
        
        parse("*://myhost/path1/path2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authority("myhost"), .path("path1"), .path("path2")])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("*://myhost/<var1: string>/path2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authority("myhost"), .pathVariable, .path("path2")])
            XCTAssertEqual(context.pathVars, [URLVariable(name: "var1", type: "string")])
            XCTAssertNil(context.queryVars)
        }))
        
        parse("*://myhost/*/path2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authority("myhost"), .pathWildcard, .path("path2")])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("http://*", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.scheme("http"), .authorityWildcard])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("http://*", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.scheme("http"), .authorityWildcard])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("*://*", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authorityWildcard])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("*://*/path1/path2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authorityWildcard, .path("path1"), .path("path2")])
            XCTAssertNil(context.pathVars)
            XCTAssertNil(context.queryVars)
        }))
        
        parse("*://*/<var1: int>/path2", assertion: parseSuccess({ (context) in
            XCTAssertEqual(context.patterns, [.schemeWildcard, .authorityWildcard, .pathVariable, .path("path2")])
            XCTAssertEqual(context.pathVars, [URLVariable(name: "var1", type: "int")])
            XCTAssertNil(context.queryVars)
        }))
        
        // URLVariable can't be host or scheme
        parse("https://www.example.com/user/<v1>", assertion: parseFailed(.unresolvedURLVariable))
        parse("https://www.example.com/user/<v1:string>/old/<v1:int>", assertion: parseFailed(.ambiguousURLVariable))
        parse("https://www.example.com/user/<q1:string>?q1=<int>&q2=<bool>", assertion: parseFailed(.ambiguousURLVariable))
        parse("https://www.example.com/user/<uname:string>?q1=<int>&q1=<bool>", assertion: parseFailed(.ambiguousURLVariable))
        
        parse("@://host/path>", assertion: parseFailed(.underlying))
        parse("_://host/path>", assertion: parseFailed(.underlying))
        parse("101://host/path>", assertion: parseFailed(.underlying))
        parse("1abc://host/path>", assertion: parseFailed(.underlying))
    }
}
