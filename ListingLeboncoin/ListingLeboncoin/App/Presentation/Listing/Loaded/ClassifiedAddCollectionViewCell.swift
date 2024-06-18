//
// Created by Marius Cotfas
// 
//


import Combine
import UIKit

final class ClassifiedAddCollectionViewCell: UICollectionViewCell {
    private let imageViewModel = ImageViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var imageTask: Task<(), Never>?
    private var uiModel: ClassifiedAddUIModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        listenImageStateChanges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    func configure(with uiModel: ClassifiedAddUIModel) {
        self.uiModel = uiModel
        
        titleLabel.text = uiModel.title
        categoryLabel.text = uiModel.categoryName
        priceLabel.text = uiModel.price
                        
        isUrgentView.isHidden = !uiModel.isUrgent
        
        loadImage()
    }
    
    private func loadImage() {
        imageTask?.cancel()
        imageTask = Task {
            await imageViewModel.getImageData(for: uiModel?.imageSmallURLString)
        }
    }
    
    @objc private func reloadImage() {
        loadImage()
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
                break
                
            case .error:
                self.reloadImageButton.isHidden = false
                
            }
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = .white
        
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private lazy var contentStackView: UIStackView = {
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
        ViewsFactory.makeImageView(
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
        let label = ViewsFactory.makeTitleLabel(lines: 2)
        
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        
        return label
    }()
}
