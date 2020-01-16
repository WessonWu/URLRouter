import XCTest
import URLRouter

class TestURLVariable: XCTestCase {
    func testVariableInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(URLVariable(path: "var: int")?.type, "int")
        XCTAssertEqual(URLVariable(path: "var: iNt")?.type, "int")
        XCTAssertEqual(URLVariable(path: "var: inT")?.type, "int")
        XCTAssertEqual(URLVariable(path: "var: INT")?.type, "int")
        XCTAssertEqual(URLVariable(path: "var: Int")?.type, "int")
        
        let var1 = URLVariable(path: "username: String")
        let var2 = URLVariable(path: "username: int")
        
        XCTAssertEqual(var1?.name, "username")
        XCTAssertEqual(var2?.name, "username")
        XCTAssertEqual(var1?.type, "string")
        XCTAssertEqual(var2?.type, "int")
        XCTAssertEqual(var1, var2)
        
        XCTAssertNil(URLVariable(path: ""))
        XCTAssertNil(URLVariable(path: "username"))
        XCTAssertNil(URLVariable(path: "username:"))
        XCTAssertNil(URLVariable(path: " :int"))
        XCTAssertNil(URLVariable(path: "   :   int"))
        XCTAssertNil(URLVariable(path: ":"))
    }
}
