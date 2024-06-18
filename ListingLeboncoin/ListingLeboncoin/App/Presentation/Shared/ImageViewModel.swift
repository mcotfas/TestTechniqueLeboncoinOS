//
// Created by Marius Cotfas
// 
//
    

import Combine
import Foundation

struct ImageViewModel {
    enum State {
        case loading
        case loaded(imageData: Data)
        case noImage
        case error
    }

    private let imageUseCase: ImageUseCase
    
    private let imageSubject: CurrentValueSubject<State, Never> = CurrentValueSubject(.loading)
    var imagePublisher: AnyPublisher<State, Never> {
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
