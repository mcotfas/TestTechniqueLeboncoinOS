//
// Created by Marius Cotfas
// 
//
    

import Foundation

struct ClassifiedAddDomainModel {
    let id: Int
    let categoryName: String
    let title: String
    let description: String
    let price: Double
    let isUrgent: Bool    
    let creationDate: Date
    let siret: String?
    
    let imageSmallURLString: String?
    let imageThumbURLString: String?
}
