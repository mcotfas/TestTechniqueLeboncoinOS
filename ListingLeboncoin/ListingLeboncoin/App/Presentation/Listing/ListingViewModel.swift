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
    private let classifiedAddUIMapper: ClassifiedAddUIMapper
    private let stateSubject: CurrentValueSubject<ViewState, Never> = CurrentValueSubject(.loading)
    
    init(
        listingUseCase: ListingUseCase = ListingUseCaseImpl(),
        classifiedAddUIMapper: ClassifiedAddUIMapper = ClassifiedAddUIMapperImpl()
    ) {
        self.listingUseCase = listingUseCase
        self.classifiedAddUIMapper = classifiedAddUIMapper
    }
    
    var state: AnyPublisher<ViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
 
    func loadListing() async {
        stateSubject.send(.loading)
        
        do {
            let classifiedAddsDomainModel = try await listingUseCase.getSortedListing()
            
            let classifiedAddsUIModel = classifiedAddsDomainModel.map {
                classifiedAddUIMapper.mapToUI(domainModel: $0)                
            }
            stateSubject.send(.loaded(classifiedAddsUIModels: classifiedAddsUIModel))            
        } catch {
            stateSubject.send(.error)
        }
    }
}
