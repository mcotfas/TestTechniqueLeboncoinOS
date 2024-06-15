//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ListingDataSource {
    func fetchClassifiedAdds() async throws -> [ClassifiedAddDataModel]
}
