//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ListingUseCase {
    func getSortedListing() async throws -> [ClassifiedAddDomainModel]
}

struct ListingUseCaseImpl: ListingUseCase {
    
    private let listingRepository: ListingRepository
    
    init(listingRepository: ListingRepository = ListingRepositoryImpl()) {
        self.listingRepository = listingRepository
    }
        
    /// Returns sorted ClassifiedAdds with urgent items first
    func getSortedListing() async throws  -> [ClassifiedAddDomainModel] {
        let classifiedAdds = try await listingRepository.getClassifiedAdds()
        
        return classifiedAdds.sorted {
            $0.isUrgent && !$1.isUrgent
        }
    }
}
