import ComposableArchitecture
import Foundation

final class ProductRepository: ProductRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetch() async throws -> ProductList? {
        return try await apiClient.request(
            responseType: ProductList.self
        )
    }
}

// MARK: - DependencyKey decouple the dependency from the implementation
private enum ProductRepositoryKey: DependencyKey {
    static let liveValue: ProductRepositoryProtocol = ProductRepository()
}

extension DependencyValues {
    var productRepository: ProductRepositoryProtocol {
        get { self[ProductRepositoryKey.self] }
        set { self[ProductRepositoryKey.self] = newValue }
    }
}
