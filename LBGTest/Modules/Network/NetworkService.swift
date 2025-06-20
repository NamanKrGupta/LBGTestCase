class NetworkService {
    private let urlString: String

    init(urlString: String = "https://jsonplaceholder.typicode.com/posts") {
        self.urlString = urlString
    }

    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
