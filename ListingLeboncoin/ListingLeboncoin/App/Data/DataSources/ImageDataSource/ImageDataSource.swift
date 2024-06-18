//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ImageDataSource {
    func fetchImageData(for imageURL: URL) async throws -> Data
}
