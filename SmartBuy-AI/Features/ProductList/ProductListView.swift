import ComposableArchitecture
import SwiftUI

struct ProductListView: View {
    let store: StoreOf<ProductListReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                Group {
                    if viewStore.isLoading {
                        ProgressView("Loading products...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 15)
                    } else {
                        List(viewStore.productList?.products ?? [], id: \.id) { product in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.title ?? "")
                                    .font(.headline)
                                Text(String(format: "$%.2f", product.price ?? 0))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(
                                .vertical,
                                10
                            )
                        }
                        .padding(.top, 15)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle("Products")
                .toolbarBackground(Color.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    viewStore.send(.fetchProducts)
                }
            }
        }
    }
}
