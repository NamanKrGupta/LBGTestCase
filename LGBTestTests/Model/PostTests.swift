import XCTest
@testable import LBGTest

final class PostModelTests: XCTestCase {

    //  Valid JSON Decodes
    func testPostModelDecodesValidJSON() throws {
        let json = """
        {
            "userId": 1,
            "id": 101,
            "title": "Test Title",
            "body": "Test Body"
        }
        """.data(using: .utf8)!

        let post = try JSONDecoder().decode(Post.self, from: json)

        XCTAssertEqual(post.userId, 1)
        XCTAssertEqual(post.id, 101)
        XCTAssertEqual(post.title, "Test Title")
        XCTAssertEqual(post.body, "Test Body")
    }

    //  Missing field fails
    func testPostModelFailsMissingField() {
        let json = """
        {
            "userId": 1,
            "id": 101,
            "title": "Test Title"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Post.self, from: json))
    }

    // Extra fields ignored
    func testPostModelIgnoresExtraFields() throws {
        let json = """
        {
            "userId": 2,
            "id": 202,
            "title": "Hello",
            "body": "World",
            "extraField": "ignored"
        }
        """.data(using: .utf8)!

        let post = try JSONDecoder().decode(Post.self, from: json)
        XCTAssertEqual(post.userId, 2)
        XCTAssertEqual(post.id, 202)
    }

    //  Wrong data type causes failure
    func testPostModelFailsWithInvalidTypes() {
        let json = """
        {
            "userId": "one",
            "id": 101,
            "title": "Invalid userId",
            "body": "Body"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Post.self, from: json))
    }
}
