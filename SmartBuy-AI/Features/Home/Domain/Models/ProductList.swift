public struct ProductList: Equatable {
    public let products: [Product]
}

public struct Product: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let price: Double
    public let image: String
}
