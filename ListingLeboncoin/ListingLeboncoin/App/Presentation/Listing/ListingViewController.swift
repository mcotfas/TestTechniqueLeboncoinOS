//
// Created by Marius Cotfas
// 
//
    
import Combine
import Foundation
import UIKit

final class ListingViewController: UIViewController {
    private let viewModel: ListingViewModel
    private let isCompact: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    private var listingTask: Task<(), Never>?
    
    init(
        viewModel: ListingViewModel,
        isCompact: Bool
    ) {
        self.viewModel = viewModel
        self.isCompact = isCompact
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        listenViewState()
        loadListing()
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        title = "Listing"
        
        // Loading
        view.addSubview(loadingIndicatorView)
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Loaded
        listingLoadedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listingLoadedCollectionViewController.view)
        NSLayoutConstraint.activate([
            listingLoadedCollectionViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listingLoadedCollectionViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listingLoadedCollectionViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listingLoadedCollectionViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        listingLoadedCollectionViewController.didMove(toParent: self)
        
        // Reload
        view.addSubview(reloadButton)
        NSLayoutConstraint.activate([
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func resetUI() {
        loadingIndicatorView.isHidden = true
        listingLoadedCollectionViewController.view.isHidden = true
        reloadButton.isHidden = true
    }
    
    private func listenViewState(){
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                
                self.resetUI()
                
                switch state {
                case .loading:
                    self.loadingIndicatorView.isHidden = false
                    
                case .loaded(let classifiedAddsUIModels):
                    self.listingLoadedCollectionViewController.classifiedAddsUIModels = classifiedAddsUIModels
                    self.listingLoadedCollectionViewController.view.isHidden = false
                    
                case .error:
                    self.reloadButton.isHidden = false
                }
        }.store(in: &cancellables)
    }
    
    @objc private func loadListing() {
        listingTask?.cancel()
        listingTask = Task {
            await viewModel.loadListing()
        }
    }
    
    // MARK: Views
    
    private lazy var listingLoadedCollectionViewController: ListingLoadedCollectionViewController = {
        ListingLoadedCollectionViewController { [weak self] uiModel in
            guard let self else { return }
            
            let imageViewModel = ImageViewModel()
            let viewController = ClassifiedAddViewController(
                uiModel: uiModel,
                imageViewModel: imageViewModel
            )
            
            if self.isCompact {
                show(viewController, sender: self)
            } else {
                self.showDetailViewController(UINavigationController(rootViewController: viewController), sender: self)
            }
        }
    }()
    
    private lazy var reloadButton: UIButton = {
        ViewsFactory.makeReloadButton { [weak self] in
            self?.loadListing()
        }
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        ViewsFactory.makeLoadingIndicatorView()
    }()
}
