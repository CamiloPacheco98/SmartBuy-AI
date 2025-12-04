import Foundation

protocol ProductRepositoryProtocol {
    func fetch() async throws -> ProductList?
}
