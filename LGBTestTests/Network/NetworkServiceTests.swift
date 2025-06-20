import XCTest
@testable import LBGTest

final class NetworkServiceTests: XCTestCase {

    // Test API Success Case
    func testFetchPosts_Success() {
        let expectation = self.expectation(description: "API call succeeds")

        let service = NetworkService() // Default URL

        service.fetchPosts { result in
            switch result {
            case .success(let posts):
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
                XCTAssertNotNil(posts.first?.id, "First post must have ID")
                XCTAssertNotNil(posts.first?.title, "First post must have title")
                expectation.fulfill()

            case .failure(let error):
                XCTFail("Expected success but got failure: \(error.localizedDescription)")
            }
        }

        waitForExpectations(timeout: 5)
    }

    //  Test API Failure (Invalid URL)
    func testFetchPosts_Failure() {
        let expectation = self.expectation(description: "API call fails with invalid URL")

        let service = NetworkService(urlString: "https://invalid.url")

        service.fetchPosts { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    //  Test JSON Decoding for Post Model
    func testPostModelDecoding() throws {
        let json = """
        {
            "userId": 10,
            "id": 100,
            "title": "Test Post Title",
            "body": "This is a test body"
        }
        """.data(using: .utf8)!

        let post = try JSONDecoder().decode(Post.self, from: json)

        XCTAssertEqual(post.userId, 10)
        XCTAssertEqual(post.id, 100)
        XCTAssertEqual(post.title, "Test Post Title")
        XCTAssertEqual(post.body, "This is a test body")
    }
}
