//
// Created by Marius Cotfas
// 
//
    

import Foundation

enum ImageUseCaseFailure: Error {
    case wrongURL
}

protocol ImageUseCase {
    func getImageData(for imageURLString: String) async throws -> Data
}

struct ImageUseCaseImpl: ImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.imageRepository = imageRepository
    }
    
    func getImageData(for imageURLString: String) async throws -> Data {        
        guard let url = URL(string: imageURLString) else {
            throw ImageUseCaseFailure.wrongURL
        }
        
        return try await imageRepository.getImageData(for: url)
    }
}
