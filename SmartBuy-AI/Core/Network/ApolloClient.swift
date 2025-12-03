//
//  ApolloClient.swift
//  SmartBuy-AI
//
//  Created by Camilo Pacheco on 2/12/25.
//

import Apollo
import Foundation

extension ApolloClient {
    
    static let shared: ApolloClient = {
        let baseURL = Environment.baseURL
        return ApolloClient(url: baseURL)
    }()
}
