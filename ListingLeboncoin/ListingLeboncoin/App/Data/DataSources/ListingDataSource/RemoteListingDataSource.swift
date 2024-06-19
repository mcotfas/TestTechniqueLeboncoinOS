//
// Created by Marius Cotfas
// 
//
    

import Foundation

struct RemoteListingDataSource: ListingDataSource {
    private enum Constants {
        static var listingURLString = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    }
    
    enum Failure: Error {
        case wrongURL
    }
    
    private let client: NetworkClient
    
    init(client: NetworkClient = URLSessionNetworkClient(urlSession: URLSession.shared)) {
        self.client = client
    }
    
    func fetchClassifiedAdds() async throws -> [ClassifiedAddDataModel] {
        guard let url =  URL(string: Constants.listingURLString) else {
            throw Failure.wrongURL
        }
        
        let data = try await client.getData(for: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601        
        let offers = try decoder.decode([ClassifiedAddDataModel].self, from: data)
        
        return offers
    }
}
