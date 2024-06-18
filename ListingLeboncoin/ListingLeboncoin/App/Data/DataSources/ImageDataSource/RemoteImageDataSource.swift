//
// Created by Marius Cotfas
// 
//
    

import Foundation

struct RemoteImageDataSource: ImageDataSource {    
    private let client: NetworkClient
    
    init(client: NetworkClient = Self.makeDefaultNetworkClient()) {
        self.client = client
    }
    
    func fetchImageData(for imageURL: URL) async throws -> Data {
        try await client.getData(for: imageURL)
    }
    
    static func makeDefaultNetworkClient() -> NetworkClient {
        let urlSession = URLSession(configuration: .default)
        urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSessionNetworkClient(urlSession: urlSession)
    }
}
