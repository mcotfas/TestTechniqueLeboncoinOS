//
// Created by Marius Cotfas
// 
//
    
import Foundation

struct URLSessionNetworkClient: NetworkClient {
    let urlSession: URLSession
        
    func getData(for url: URL) async throws -> Data {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
