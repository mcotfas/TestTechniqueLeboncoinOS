//
// Created by Marius Cotfas
// 
//
    

import UIKit

#warning("TODO: Remove before prod")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor.blue
        
        let remoteClient = URLSessionNetworkClient(
            urlSession: URLSession.shared
        )
        let listingDataSource = RemoteListingDataSource(
            client: remoteClient
        )
        
        let categoriesDataSource = RemoteCategoriesDataSource(
            client: remoteClient
        )
        
        Task {
            let categories = try await categoriesDataSource.fetchCategories()
            
            categories.forEach { item in
                print(item.name)
            }
            
            
            let adds = try await listingDataSource.fetchClassifiedAdds()
            
            adds.forEach { item in
                print(item.title)
            }
        }
        
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}


