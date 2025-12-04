import Foundation

public struct ProductListDTO: Decodable {
    let products: [ProductDTO]

    func toDomain() -> ProductList {
        return ProductList(products: products.map { $0.toDomain() })
    }
}

public struct ProductDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let image: String

    func toDomain() -> Product {
        return Product(id: id, title: title, description: description, price: price, image: image)
    }
}
