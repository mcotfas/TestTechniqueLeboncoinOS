//
// Created by Marius Cotfas
// 
//
    

import Foundation
import UIKit

final class AppSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                                
        // Set view controllers
        let listingViewModel = ListingViewModel()
        
        self.setViewController(
            ListingViewController(viewModel: listingViewModel, isCompact: false),
            for: .primary
        )
        self.setViewController(
            UINavigationController(rootViewController: EmptyViewController()),
            for: .secondary
        )
        self.setViewController(
            UINavigationController(rootViewController: ListingViewController(viewModel: listingViewModel, isCompact: true)),
            for: .compact
        )
        
        // Set display
        self.minimumPrimaryColumnWidth = 500
        self.maximumPrimaryColumnWidth = 500
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
