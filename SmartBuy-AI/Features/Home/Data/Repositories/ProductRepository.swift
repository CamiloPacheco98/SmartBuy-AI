import ComposableArchitecture
import Foundation

final class ProductRepository: ProductRepositoryProtocol {
    private let apiClient: APIClient
    private let remote: RemoteProductDataSource

    init(
        apiClient: APIClient = .shared, remote: RemoteProductDataSource = RemoteProductDataSource()
    ) {
        self.apiClient = apiClient
        self.remote = remote
    }

    func fetch() async throws -> ProductList {
        do {
            let response = try await remote.fetchProducts()
            return response.toDomain()
        } catch {
            throw error
        }
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
