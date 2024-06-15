//
// Created by Marius Cotfas
// 
//
    

import UIKit

#warning("TODO: Remove before prod")

class ViewController: UIViewController {
    
    private let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = color
        
        let remoteClient = URLSessionNetworkClient(
            urlSession: URLSession.shared
        )
        let listingDataSource = RemoteListingDataSource(
            client: remoteClient
        )
        
        let categoriesDataSource = RemoteCategoriesDataSource(
            client: remoteClient
        )
        
        let listingRepository = ListingRepositoryImpl(
            listingDataSource: listingDataSource,
            categoriesDataSource: categoriesDataSource,
            classifiedAddDomainMapper: ClassifiedAddDomainMapperImpl()
        )
        
        Task {
            let adds = try await listingRepository.getClassifiedAdds()
            
            adds.forEach { add in
                print("\(add.categoryName) - \(add.title)")
            }
        }
        
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController(color: .blue)
}


