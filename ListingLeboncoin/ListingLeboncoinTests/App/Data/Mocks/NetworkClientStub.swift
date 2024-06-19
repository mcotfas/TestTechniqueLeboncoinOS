//
// Created by Marius Cotfas
// 
//
    

import Foundation
@testable import ListingLeboncoin

final class NetworkClientStub: NetworkClient {
    var dataStub: Data!
    var errorStub: Error?

    private(set) var urls: [URL] = []
        
    func getData(for url: URL) async throws -> Data {
        urls.append(url)
        
        if let errorStub {
            throw errorStub
        }
        
        return dataStub
    }
}
