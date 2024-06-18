//
// Created by Marius Cotfas
// 
//
    

import Foundation
import UIKit

protocol ClassifiedAddViewModel {}

struct ClassifiedAddViewModelImpl: ClassifiedAddViewModel {
    
}

final class ClassifiedAddViewController: UIViewController {
    private let viewModel: ClassifiedAddViewModel
    
    init(viewModel: ClassifiedAddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
