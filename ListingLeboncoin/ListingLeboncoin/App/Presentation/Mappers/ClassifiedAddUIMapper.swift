//
// Created by Marius Cotfas
// 
//
    

import Foundation

protocol ClassifiedAddUIMapper {
    func mapToUI(domainModel: ClassifiedAddDomainModel) -> ClassifiedAddUIModel
}

struct ClassifiedAddUIMapperImpl: ClassifiedAddUIMapper {
    func mapToUI(domainModel: ClassifiedAddDomainModel) -> ClassifiedAddUIModel {
        
        let locale = Locale(identifier: "fr_FR")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        let price = formatter.string(from: NSNumber(value: domainModel.price)) ?? "-"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = locale
        let creationDate = dateFormatter.string(from: domainModel.creationDate)
        
        return ClassifiedAddUIModel(
            id: domainModel.id,
            categoryName: domainModel.categoryName,
            title: domainModel.title,
            description: domainModel.description,
            price: price,
            isUrgent: domainModel.isUrgent,
            creationDate: creationDate,
            siret: domainModel.siret,
            imageSmallURLString: domainModel.imageSmallURLString,
            imageThumbURLString: domainModel.imageThumbURLString
        )        
    }
}
