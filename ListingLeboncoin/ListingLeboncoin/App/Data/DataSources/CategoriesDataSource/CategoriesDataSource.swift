//
// Created by Marius Cotfas
// 
//
    
import Foundation

protocol CategoriesDataSource {
    func fetchCategories() async throws -> [CategoryDataModel]
}
