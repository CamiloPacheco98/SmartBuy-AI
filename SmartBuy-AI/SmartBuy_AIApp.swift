//
//  SmartBuy_AIApp.swift
//  SmartBuy-AI
//
//  Created by Camilo Pacheco on 18/07/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct SmartBuy_AIApp: App {
    var body: some Scene {
        WindowGroup {
            ProductListView(
                store: Store(initialState: ProductListReducer.State()) {
                    ProductListReducer()
                }
            )
        }
    }
}
