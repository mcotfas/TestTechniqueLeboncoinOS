//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol CategoriesDataSource {
    func fetchCategories() async throws -> [CategoryDataModel]
}

struct RemoteCategoriesDataSource: CategoriesDataSource {
    private enum Constants {
        static var listingURLString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    }
    
    enum Failure: Error {
        case wrongURL
    }
    
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func fetchCategories() async throws -> [CategoryDataModel] {
        guard let url = URL(string: Constants.listingURLString) else {
            throw Failure.wrongURL
        }
        
        let data = try await client.getData(for: url)
        
        let decoder = JSONDecoder()
        
        let categories = try decoder.decode([CategoryDataModel].self, from: data)
        
        return categories        
    }
}
