import XCTest
@testable import LBGTest

final class DefaultFetchPostsUseCaseTests: XCTestCase {

    // Success case
    func testExecuteReturnsPosts() async throws {
        // Given
        let expectedPosts = [
            Post(userId: 1, id: 1, title: "Test 1", body: "Body 1"),
            Post(userId: 2, id: 2, title: "Test 2", body: "Body 2")
        ]
        let mockService = MockNetworkService(posts: expectedPosts)
        let useCase = DefaultFetchPostsUseCase(networkService: mockService)

        // When
        let posts = try await useCase.execute()

        // Then
        XCTAssertEqual(posts.count, expectedPosts.count)
        XCTAssertEqual(posts.first?.title, "Test 1")
    }

    // Failure case
    func testExecuteThrowsError() async {
        // Given
        let mockService = MockNetworkService(error: URLError(.notConnectedToInternet))
        let useCase = DefaultFetchPostsUseCase(networkService: mockService)

        // When / Then
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
