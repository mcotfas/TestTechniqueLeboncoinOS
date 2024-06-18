//
// Created by Marius Cotfas
// 
//
    
import Combine
import Foundation
import UIKit

final class ClassifiedAddViewController: UIViewController {
    private let uiModel: ClassifiedAddUIModel
    private let imageViewModel: ImageViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var imageTask: Task<(), Never>?
    
    init(
        uiModel: ClassifiedAddUIModel,
        imageViewModel: ImageViewModel
    ) {
        self.uiModel = uiModel
        self.imageViewModel = imageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
//        loadImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        listenImageStateChanges()        
        loadImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "ClassifiedAdd"
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
                
        isUrgentView.isHidden = !uiModel.isUrgent
        categoryLabel.text = uiModel.categoryName
        priceLabel.text = uiModel.price
        titleLabel.text = uiModel.title
        descriptionLabel.text = uiModel.description
        siretLabel.text = uiModel.siret
    }
    
    private func listenImageStateChanges() {
        imageViewModel.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
            guard let self else { return }
                
            self.imageView.image = nil
            self.loadingIndicatorView.isHidden = true
            self.reloadImageButton.isHidden = true
            
            switch state {
            case .loading:
                self.loadingIndicatorView.isHidden = false
                
            case .loaded(let imageData):
                self.imageView.image = UIImage(data: imageData)
                
            case .noImage:
                self.imageView.image = UIImage(systemName: "photo")
                
            case .error:
                self.reloadImageButton.isHidden = false
                
            }
        }.store(in: &cancellables)
    }
    
    private func loadImage() {
        imageTask?.cancel()
        imageTask = Task {
            await imageViewModel.getImageData(for: uiModel.imageThumbURLString)
        }
    }
    
    @objc private func reloadImage() {
        loadImage()
    }
    
    // MARK: Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
                
        scrollView.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        scrollView.contentSize = containerStackView.frame.size
        
        return scrollView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
               
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(siretLabel)
        
        return stackView
    }()
    
    private lazy var isUrgentView: UIImageView = {
        ViewsFactory.makeIsUrgentView()
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        ViewsFactory.makeLoadingIndicatorView()
    }()
    
    private lazy var reloadImageButton: UIButton = {
        ViewsFactory.makeReloadButton { [weak self] in
            self?.reloadImage()
        }
    }()
    
    private lazy var imageView: UIImageView = {
        return ViewsFactory.makeImageView(
            isUrgentView: isUrgentView,
            loadingIndicatorView: loadingIndicatorView,
            reloadImageButton: reloadImageButton
        )
    }()
    
    private lazy var categoryLabel: UILabel = {
        ViewsFactory.makeCategoryLabel()
    }()
    
    private lazy var priceLabel: UILabel = {
        ViewsFactory.makePriceLabel()
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ViewsFactory.makeTitleLabel(lines: 0)                
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        ViewsFactory.makeDescriptionLabel()
    }()
    
    private var siretLabel: UILabel = {
        ViewsFactory.makeSiretLabel()
    }()
}
