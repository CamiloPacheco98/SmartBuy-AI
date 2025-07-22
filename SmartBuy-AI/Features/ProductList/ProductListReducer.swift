import ComposableArchitecture
import Foundation

@Reducer
struct ProductListReducer {

    @Dependency(\.productRepository) var productRepository

    @ObservableState
    struct State: Equatable {
        var productList: ProductList?
        var isLoading: Bool = false
    }

    enum Action {
        case fetchProducts
        case productsResponse(Result<ProductList, Error>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchProducts:
                state.isLoading = true
                return .run { send in
                    if let productList = try await productRepository.fetch() {
                        await send(.productsResponse(Result.success(productList)))
                    } else {
                        await send(
                            .productsResponse(
                                Result.failure(
                                    NSError(domain: "ProductList", code: 0, userInfo: nil))))
                    }
                }
            case let .productsResponse(.success(productList)):
                state.productList = productList
                state.isLoading = false
                return .none
            case let .productsResponse(.failure(error)):
                state.isLoading = false
                print(error)
                return .none
            }
        }
    }
}
