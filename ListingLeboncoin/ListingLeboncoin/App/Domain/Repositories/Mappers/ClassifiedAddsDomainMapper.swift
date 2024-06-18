//
// Created by Marius Cotfas
// 
//
    
import Foundation

protocol ClassifiedAddsDomainMapper {
    func mapToDomain(
        from classifiedAddsDataModel: [ClassifiedAddDataModel],
        with categories: [CategoryDataModel]
    ) -> [ClassifiedAddDomainModel]
}

struct ClassifiedAddDomainMapperImpl: ClassifiedAddsDomainMapper {
    func mapToDomain(
        from classifiedAddsDataModel: [ClassifiedAddDataModel],
        with categoriesDataModel: [CategoryDataModel]
    ) -> [ClassifiedAddDomainModel] {
        
        classifiedAddsDataModel.compactMap { classifiedAddDataModel -> ClassifiedAddDomainModel? in
            guard let categoryName = categoriesDataModel.first(where: { $0.id == classifiedAddDataModel.categoryId })?.name else {
                return nil
            }
            
            return ClassifiedAddDomainModel(
                id: classifiedAddDataModel.id,
                categoryName: categoryName,
                title: classifiedAddDataModel.title,
                description: classifiedAddDataModel.description,
                price: classifiedAddDataModel.price,
                isUrgent: classifiedAddDataModel.isUrgent,
                imageSmallURLString: classifiedAddDataModel.imagesUrl.small,
                imageThumbURLString: classifiedAddDataModel.imagesUrl.thumb
            )
        }
    }
}
