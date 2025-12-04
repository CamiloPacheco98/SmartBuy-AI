import Apollo
import MockShopAPI

struct RemoteProductDataSource {
    func fetchProducts() async throws -> ProductListDTO {
        let response = try await ApolloClient.shared.fetch(query: ProductListQuery())
        guard let data = response.data else {
            throw APIError.invalidResponse
        }
        return ProductListDTO(
            products: data.products.edges.compactMap { edge -> ProductDTO? in
                let node = edge.node
                let price = node.variants.edges.first?.node.price.amount ?? "0.0"
                let image = node.featuredImage?.url ?? ""
                return ProductDTO(
                    id: node.id, title: node.title, description: node.description,
                    price: Double(price) ?? 0.0, image: image)
            })
    }
}
