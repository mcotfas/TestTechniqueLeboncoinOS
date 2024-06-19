//
// Created by Marius Cotfas
// 
//
    

import XCTest
@testable import ListingLeboncoin

final class RemoteImageDataSourceTests: XCTestCase {
    typealias SUT = RemoteImageDataSource
    
    func test_fetchImageData_GIVEN_client_error_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        let anyError = AnyErrorTestValue()
        
        mocks.networkClient.errorStub = anyError
        
        do {
            // ACT
            _ = try await sut.fetchImageData(for: url)
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertEqual(error as? AnyErrorTestValue, anyError)
        }
    }
    
    func test_fetchImageData_GIVEN_client_success_SHOULD_return_data() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        let anyData = "any data".data(using: .utf8)
        
        mocks.networkClient.dataStub = anyData
        
        // ACT
        let data = try await sut.fetchImageData(for: url)
        
        // ASSERT
        XCTAssertEqual(data, anyData)
    }
    
    // MARK: Helpers
    
    private struct Mocks {
        let networkClient: NetworkClientStub
    }
    
    private func makeSutAndMocks() -> (SUT, Mocks) {
        let mocks = Mocks(
            networkClient: NetworkClientStub()
        )
        
        let sut = RemoteImageDataSource(client: mocks.networkClient)
        
        return (sut, mocks)
    }
}

// MARK: Mocks
