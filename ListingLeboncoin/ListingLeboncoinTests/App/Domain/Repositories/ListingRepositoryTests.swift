//
// Created by Marius Cotfas
// 
//
    

import XCTest
@testable import ListingLeboncoin

final class ListingRepositoryTests: XCTestCase {
    typealias SUT = ListingRepository
    
    func test_getClassifiedAdds_GIVEN_categoriesDataSource_failure_SHOULD_throw() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.categoriesDataSource.errorStub = anyError
        
        do {
            // ACT
            _ = try await sut.getClassifiedAdds()
            XCTFail("Should throw")
        } catch {
            // ASSERT
            XCTAssertEqual(error as? AnyErrorTestValue, anyError)
        }
    }
    
    func test_getClassifiedAdds_GIVEN_listingDataSource_failure_SHOULD_throw() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.categoriesDataSource.categoriesStub = []
        mocks.listingDataSource.errorStub = anyError
        
        do {
            // ACT
            _ = try await sut.getClassifiedAdds()
            XCTFail("Should throw")
        } catch {
            // ASSERT
            XCTAssertEqual(error as? AnyErrorTestValue, anyError)
        }
    }
    
    func test_getClassifiedAdds_GIVEN_dataSources_success_SHOULD_return_mapped_domainModels() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        let categoryDataModel = CategoryDataModel(id: 1, name: "cat")
        let classifiedAddDataModel = ClassifiedAddDataModel(
            id: 1,
            title: "titile",
            categoryId: 2,
            creationDate: Date(),
            description: "desc",
            isUrgent: true,
            imagesUrl: ImagesURL(small: nil, thumb: nil),
            price: 42.00,
            siret: nil
        )
        
        let classifiedAddDomainModel = ClassifiedAddDomainModel(
            id: 1,
            categoryName: "name",
            title: "title",
            description: "description",
            price: 42.00,
            isUrgent: true,
            creationDate: Date(),
            siret: nil,
            imageSmallURLString: nil,
            imageThumbURLString: nil
        )
        
        mocks.categoriesDataSource.categoriesStub = [categoryDataModel]
        mocks.listingDataSource.classifiedAdds = [classifiedAddDataModel]
        mocks.classifiedAddsDomainMapper.classifiedAddsStub = [classifiedAddDomainModel]
        
        // ACT
        let classifiedAddsDomain = try await sut.getClassifiedAdds()
        
        // ASSERT
        XCTAssertEqual(mocks.categoriesDataSource.callCount, 1)
        XCTAssertEqual(mocks.listingDataSource.callCount, 1)
        
        XCTAssertEqual(mocks.classifiedAddsDomainMapper.categoriesDataModels, [[categoryDataModel]])
        XCTAssertEqual(mocks.classifiedAddsDomainMapper.classifiedAddsDataModels, [[classifiedAddDataModel]])
        
        XCTAssertEqual(classifiedAddsDomain, [classifiedAddDomainModel])
    }
    
    // MARK: Helpers
    
    private struct Mocks {
        let listingDataSource: ListingDataSourceStub
        let categoriesDataSource: CategoriesDataSourceStub
        let classifiedAddsDomainMapper: ClassifiedAddsDomainMapperStub
    }
    
    private func makeSutAndMocks() -> (SUT, Mocks) {
        let mocks = Mocks(
            listingDataSource: ListingDataSourceStub(),
            categoriesDataSource: CategoriesDataSourceStub(),
            classifiedAddsDomainMapper: ClassifiedAddsDomainMapperStub()
        )
        
        let sut = ListingRepositoryImpl(
            listingDataSource: mocks.listingDataSource,
            categoriesDataSource: mocks.categoriesDataSource,
            classifiedAddDomainMapper: mocks.classifiedAddsDomainMapper
        )
        
        return (sut, mocks)
    }
}

// MARK: Mocks

final class ListingDataSourceStub: ListingDataSource {
    var classifiedAdds: [ClassifiedAddDataModel]!
    var errorStub: Error?
    
    private(set) var callCount = 0
            
    func fetchClassifiedAdds() async throws -> [ClassifiedAddDataModel] {
        callCount += 1
        
        if let errorStub {
            throw errorStub
        }
        
        return classifiedAdds
    }
}

final class CategoriesDataSourceStub: CategoriesDataSource {
    var categoriesStub: [CategoryDataModel]!
    var errorStub: Error?
    
    private(set) var callCount = 0
    
    func fetchCategories() async throws -> [CategoryDataModel] {
        callCount += 1
        
        if let errorStub {
            throw errorStub
        }
        
        return categoriesStub
    }
}

final class ClassifiedAddsDomainMapperStub: ClassifiedAddsDomainMapper {
    var classifiedAddsStub: [ClassifiedAddDomainModel]!
    
    private(set) var classifiedAddsDataModels: [[ClassifiedAddDataModel]] = []
    private(set) var categoriesDataModels: [[CategoryDataModel]] = []
    
    func mapToDomain(
        from classifiedAddsDataModel: [ClassifiedAddDataModel],
        with categoriesDataModel: [CategoryDataModel]
    ) -> [ClassifiedAddDomainModel] {
        
        classifiedAddsDataModels.append(classifiedAddsDataModel)
        categoriesDataModels.append(categoriesDataModel)
        
        return classifiedAddsStub
    }
}
    

