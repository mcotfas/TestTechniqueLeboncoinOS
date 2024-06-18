//
// Created by Marius Cotfas
// 
//
    

import Foundation

struct ClassifiedAddUIModel {
    let id: Int
    let categoryName: String
    let title: String
    let description: String
    let price: String
    let isUrgent: Bool
    let creationDate: String
    let siret: String?
    
    let imageSmallURLString: String?
    let imageThumbURLString: String?
}
