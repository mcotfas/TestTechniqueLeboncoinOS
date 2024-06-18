//
// Created by Marius Cotfas
// 
//
    

import Combine
import Foundation

struct ClassifiedAddCollectionViewModelCell {
    enum ImageState {
        case loading
        case loaded(imageData: Data)
        case noImage
        case error
    }

    private let imageUseCase: ImageUseCase
    
    private let imageSubject: CurrentValueSubject<ImageState, Never> = CurrentValueSubject(.loading)
    var imagePublisher: AnyPublisher<ImageState, Never> {
        imageSubject.eraseToAnyPublisher()
    }
        
    init(imageUseCase: ImageUseCase = ImageUseCaseImpl()) {
        self.imageUseCase = imageUseCase
    }
    
    func getImageData(for imageUrl: String?) async {
        guard let imageUrl else {
            imageSubject.send(.noImage)
            return
        }
        
        imageSubject.send(.loading)
        
        do {
            let imageData = try await imageUseCase.getImageData(for: imageUrl)
            imageSubject.send(.loaded(imageData: imageData))
            
        } catch {
            imageSubject.send(.error)
        }
    }
}
