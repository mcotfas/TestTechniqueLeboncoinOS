//
// Created by Marius Cotfas
// 
//
    

import XCTest
@testable import ListingLeboncoin

final class RemoteCategoriesDataSourceTests: XCTestCase {
    typealias SUT = RemoteCategoriesDataSource
    
    func test_fetchCategories_GIVEN_client_error_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.networkClient.errorStub = anyError
        
        do {
            // ACT
            _ = try await sut.fetchCategories()
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertEqual(error as? AnyErrorTestValue, anyError)
        }
    }
    
    func test_fetchCategories_GIVEN_wrong_data_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.networkClient.dataStub = "wrong_data".data(using: .utf8)
        
        do {
            // ACT
            _ = try await sut.fetchCategories()
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_fetchCategories_GIVEN_correct_data_SHOULD_return_dataModels() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        
        mocks.networkClient.dataStub = correctData
        
        // ACT
        let dataModels = try await sut.fetchCategories()
        
        // ASSERT                
        XCTAssertEqual(dataModels, [CategoryDataModel(id: 1, name: "Véhicule")])
    }

    // MARK: Helpers
    
    private struct Mocks {
        let networkClient: NetworkClientStub
    }
    
    private func makeSutAndMocks() -> (SUT, Mocks) {
        let mocks = Mocks(
            networkClient: NetworkClientStub()
        )
        
        let sut = RemoteCategoriesDataSource(client: mocks.networkClient)
        
        return (sut, mocks)
    }
    
    
    private var correctData: Data {
        """
        [
          {
            "id": 1,
            "name": "Véhicule"
          }
        ]
        """.data(using: .utf8)!
    }
}
