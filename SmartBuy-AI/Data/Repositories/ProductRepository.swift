import ComposableArchitecture
import MockShopAPI
import Foundation
import Apollo

final class ProductRepository: ProductRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetch() async throws -> ProductList? {
        do {
            let response = try await ApolloClient.shared.fetch(query: ProductListQuery())
            
            if let errors = response.errors {
                print("Error fetching products: \(errors)")
                return nil
            }
            
            guard let data = response.data else {
                return nil
            }
            
            let products = data.products.edges.compactMap { edge -> Product? in
                let node = edge.node
                
                // Extract price from first variant if available
                let price: Double? = {
                    guard let firstVariant = node.variants.edges.first?.node else {
                        return nil
                    }
                    // Convert Decimal to Double
                    let amountString = String(describing: firstVariant.price.amount)
                    return Double(amountString)
                }()
                
                // Convert GraphQL ID to Int (using hash as fallback if parsing fails)
                let productId: Int = {
                    let idString = String(describing: node.id)
                    // Try to extract numeric part from GraphQL ID (e.g., "gid://shopify/Product/123" -> 123)
                    if let numericPart = idString.components(separatedBy: "/").last,
                       let id = Int(numericPart) {
                        return id
                    }
                    // Fallback to hash if parsing fails
                    return abs(idString.hashValue)
                }()
                
                return Product(
                    id: productId,
                    title: node.title,
                    description: node.description,
                    category: nil,
                    price: price,
                    discountPercentage: nil,
                    rating: nil,
                    stock: nil,
                    tags: nil,
                    brand: nil,
                    sku: nil,
                    weight: nil,
                    dimensions: nil,
                    warrantyInformation: nil,
                    shippingInformation: nil,
                    availabilityStatus: nil,
                    reviews: nil,
                    returnPolicy: nil,
                    minimumOrderQuantity: nil,
                    meta: nil,
                    thumbnail: node.featuredImage?.url,
                    images: node.featuredImage != nil ? [node.featuredImage!.url] : nil
                )
            }
            
            return ProductList(products: products)
        } catch {
            print("Failure! Error - \(error)")
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
