//
// Created by Marius Cotfas
// 
//
    

import XCTest
@testable import ListingLeboncoin

final class URLSessionNetworkClientTests: XCTestCase {
    typealias SUT = URLSessionNetworkClient

    func test_getData_SHOULD_call_urlSession_data_with_correct_urlRequest() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        
        mocks.urlSession.dataStub = "anyData".data(using: .utf8)
        mocks.urlSession.urlResponseStub = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // ACT
        _ = try await sut.getData(for: url)
                
        // ASSERT
        XCTAssertEqual(mocks.urlSession.urlRequests.count, 1)
        let urlRequest = try XCTUnwrap(mocks.urlSession.urlRequests.first)
        
        XCTAssertEqual(urlRequest.url, url)
        XCTAssertEqual(urlRequest.httpMethod, "GET")        
    }
    
    func test_getData_GIVEN_nonHTTPResponse_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        
        mocks.urlSession.dataStub = "anyData".data(using: .utf8)
        mocks.urlSession.urlResponseStub = URLResponse()
                
        do {
            // ACT
            let _ = try await sut.getData(for: url)
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse)
        }
    }
    
    func test_getData_GIVEN_HTTPResponse_AND_nonValidStatusCode_SHOULD_throw_error() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        
        mocks.urlSession.dataStub = "anyData".data(using: .utf8)
        mocks.urlSession.urlResponseStub = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            // ACT
            let _ = try await sut.getData(for: url)
            XCTFail("Should throw error")
        } catch {
            // ASSERT
            XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse)
        }
    }
    
    func test_getData_GIVEN_HTTPResponse_AND_validStatusCode_SHOULD_return_data() async throws {
        // ARRANGE
        let (sut, mocks) = makeSutAndMocks()
        let url = URL(string: "anyURL")!
        
        mocks.urlSession.dataStub = "anyData".data(using: .utf8)
        mocks.urlSession.urlResponseStub = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // ACT
        let data = try await sut.getData(for: url)
        
        // ASSERT
        XCTAssertEqual(data, mocks.urlSession.dataStub)
    }
    
    // MARK: - Helpers
    
    private struct Mocks {
        let urlSession: URLSessionStub
    }
    
    private func makeSutAndMocks() -> (SUT, Mocks) {
        let mocks = Mocks(
            urlSession: URLSessionStub()
        )
        
        let sut = URLSessionNetworkClient(urlSession: mocks.urlSession)
        
        return (sut, mocks)
    }
}

// MARK - Mocks

final class URLSessionStub: URLSessionProtocol {
    
    var dataStub: Data!
    var urlResponseStub: URLResponse!
    
    private(set) var urlRequests: [URLRequest] = []
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        urlRequests.append(request)
        return (dataStub, urlResponseStub)
    }
}
