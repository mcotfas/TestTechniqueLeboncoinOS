//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ListingRepository {
    func getClassifiedAdds() async throws -> [ClassifiedAddDomainModel]
}

struct ListingRepositoryImpl {
    private let listingDataSource: ListingDataSource
    private let categoriesDataSource: CategoriesDataSource    
    private let classifiedAddsDomainMapper: ClassifiedAddsDomainMapper
    
    init(
        listingDataSource: ListingDataSource,
        categoriesDataSource: CategoriesDataSource,
        classifiedAddDomainMapper: ClassifiedAddsDomainMapper
    ) {
        self.listingDataSource = listingDataSource
        self.categoriesDataSource = categoriesDataSource
        self.classifiedAddsDomainMapper = classifiedAddDomainMapper
    }
    
    func getClassifiedAdds() async throws -> [ClassifiedAddDomainModel] {
        let categoriesDataModel = try await categoriesDataSource.fetchCategories()
        let classifiedAddsDataModel = try await listingDataSource.fetchClassifiedAdds()
                
        return classifiedAddsDomainMapper.mapToDomain(
            from: classifiedAddsDataModel,
            with: categoriesDataModel
        )
    }
}
