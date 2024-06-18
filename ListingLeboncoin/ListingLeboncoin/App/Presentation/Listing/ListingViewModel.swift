//
// Created by Marius Cotfas
// 
//
    
import Combine
import Foundation

struct ListingViewModel {
    enum ViewState {
        case loading
        case loaded(classifiedAddsUIModels: [ClassifiedAddUIModel])
        case error
    }
    
    private let listingUseCase: ListingUseCase
    private let stateSubject: CurrentValueSubject<ViewState, Never> = CurrentValueSubject(.loading)
    
    init(listingUseCase: ListingUseCase = ListingUseCaseImpl()) {
        self.listingUseCase = listingUseCase
    }
    
    var state: AnyPublisher<ViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
 
    func loadListing() async {
        stateSubject.send(.loading)
        
        do {
            let classifiedAddsDomainModel = try await listingUseCase.getSortedListing()
                        
            #warning("TODO: Extract mapper")
            
            let classifiedAddsUIModel = classifiedAddsDomainModel.map {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "fr_FR")
                let price = formatter.string(from: NSNumber(value: $0.price)) ?? "-"
                
                return ClassifiedAddUIModel(
                    id: $0.id,
                    categoryName: $0.categoryName,
                    title: $0.title,
                    isUrgent: $0.isUrgent,
                    price: price,
                    imageSmallURLString: $0.imageSmallURLString,
                    imageThumbURLString: $0.imageThumbURLString
                )
            }
            stateSubject.send(.loaded(classifiedAddsUIModels: classifiedAddsUIModel))
            
        } catch {
            stateSubject.send(.error)
        }
    }
}
