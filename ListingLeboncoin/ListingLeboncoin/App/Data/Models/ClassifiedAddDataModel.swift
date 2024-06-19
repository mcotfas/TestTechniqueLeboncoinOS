//
// Created by Marius Cotfas
// 
//
    

import Foundation

struct ClassifiedAddDataModel: Decodable, Equatable {
    let id: Int
    let title: String
    let categoryId: Int
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImagesURL
    let price: Double
    let siret: String?
    
    private enum CodingKeys : String, CodingKey {
        case id
        case title
        case categoryId = "category_id"
        case creationDate = "creation_date"
        case description
        case isUrgent = "is_urgent"
        case imagesUrl = "images_url"
        case price
        case siret
    }
}
