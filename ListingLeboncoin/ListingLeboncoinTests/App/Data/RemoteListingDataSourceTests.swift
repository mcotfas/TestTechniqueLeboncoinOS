//
// Created by Marius Cotfas
//
//
    

import XCTest
@testable import ListingLeboncoin

final class RemoteListingDataSourceTests: XCTestCase {
    typealias SUT = RemoteListingDataSource
    
    func test_fetchClassifiedAdds_GIVEN_client_error_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.networkClient.errorStub = anyError
        
        do {
            // ACT
            _ = try await sut.fetchClassifiedAdds()
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertEqual(error as? AnyErrorTestValue, anyError)
        }
    }
    
    func test_fetchClassifiedAdds_GIVEN_wrong_data_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let anyError = AnyErrorTestValue()
        
        mocks.networkClient.dataStub = "wrong_data".data(using: .utf8)
        
        do {
            // ACT
            _ = try await sut.fetchClassifiedAdds()
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_fetchClassifiedAdds_GIVEN_correct_data_SHOULD_return_dataModels() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        
        let expectedDataModel = ClassifiedAddDataModel(
            id: 1461267313,
            title: "Statue homme noir assis en plâtre polychrome",
            categoryId: 4,
            creationDate: Date(timeIntervalSince1970: 0),
            description: "Magnifique Statuette homme noir assis fumant",
            isUrgent: false,
            imagesUrl: ImagesURL(
                small: "https://small.jpg",
                thumb: "https://thumb.jpg"
            ),
            price: 140.00,
            siret: nil
        )
        
        mocks.networkClient.dataStub = correctData
        
        // ACT
        let dataModels = try await sut.fetchClassifiedAdds()
        
        // ASSERT
        XCTAssertEqual(dataModels, [expectedDataModel])
    }

    // MARK: Helpers
    
    private struct Mocks {
        let networkClient: NetworkClientStub
    }
    
    private func makeSutAndMocks() -> (SUT, Mocks) {
        let mocks = Mocks(
            networkClient: NetworkClientStub()
        )
        
        let sut = RemoteListingDataSource(client: mocks.networkClient)
        
        return (sut, mocks)
    }
    
    
    private var correctData: Data {
        """
        [
           {
              "id":1461267313,
              "category_id":4,
              "title":"Statue homme noir assis en plâtre polychrome",
              "description":"Magnifique Statuette homme noir assis fumant",
              "price":140.00,
              "images_url":{
                 "small":"https://small.jpg",
                 "thumb":"https://thumb.jpg"
              },
              "creation_date":"1970-01-01T00:00:00+0000",
              "is_urgent":false
           }
        ]
        """.data(using: .utf8)!
    }
}

