import XCTest
@testable import LBGTest

@MainActor
final class PostsViewModelTests: XCTestCase {

    // Test successful load
    func testLoadPostsSuccess() async {
        // Given
        let mockPosts = [Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")]
        let mockUseCase = MockFetchPostsUseCase(result: .success(mockPosts))
        let viewModel = PostsViewModel(fetchPostsUseCase: mockUseCase)

        // When
        await viewModel.loadPosts()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Title")
    }

    // Test failure with error
    func testLoadPostsFailure() async {
        // Given
        let mockError = URLError(.notConnectedToInternet)
        let mockUseCase = MockFetchPostsUseCase(result: .failure(mockError))
        let viewModel = PostsViewModel(fetchPostsUseCase: mockUseCase)

        // When
        await viewModel.loadPosts()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.posts.isEmpty)
    }

    // Test loading state transitions
    func testIsLoadingStateWhileLoading() async {
        // Given
        let expectation = XCTestExpectation(description: "Wait for loading flag")
        let mockUseCase = DelayedFetchPostsUseCase(delay: 0.2, result: .success([]))
        let viewModel = PostsViewModel(fetchPostsUseCase: mockUseCase)

        Task {
            await viewModel.loadPosts()
            expectation.fulfill()
        }

        // Immediately check loading state
        XCTAssertTrue(viewModel.isLoading)

        // Wait for completion
        await fulfillment(of: [expectation], timeout: 1.0)

        // Then
        XCTAssertFalse(viewModel.isLoading)
    }
}
