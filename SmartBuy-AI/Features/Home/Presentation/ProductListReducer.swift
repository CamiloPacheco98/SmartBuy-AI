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
                    do {
                        let productList = try await productRepository.fetch()
                        await send(.productsResponse(Result.success(productList)))
                    } catch {
                        await send(.productsResponse(Result.failure(error)))
                    }
                }
            case .productsResponse(.success(let productList)):
                state.productList = productList
                state.isLoading = false
                return .none
            case .productsResponse(.failure(let error)):
                state.isLoading = false
                print(error)
                return .none
            }
        }
    }
}
