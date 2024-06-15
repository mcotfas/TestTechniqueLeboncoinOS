//
// Created by Marius Cotfas
// 
//

import Foundation

protocol NetworkClient {
    func getData(for url: URL) async throws -> Data
}
