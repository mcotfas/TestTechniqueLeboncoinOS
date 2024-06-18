//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ImageRepository {
    func getImageData(for urlImage: URL) async throws -> Data
}

struct ImageRepositoryImpl: ImageRepository {
    private let imageDataSource: ImageDataSource
    
    init(imageDataSource: ImageDataSource = RemoteImageDataSource()) {
        self.imageDataSource = imageDataSource
    }
    
    func getImageData(for urlImage: URL) async throws -> Data {
        try await imageDataSource.fetchImageData(for: urlImage)
    }        
}


