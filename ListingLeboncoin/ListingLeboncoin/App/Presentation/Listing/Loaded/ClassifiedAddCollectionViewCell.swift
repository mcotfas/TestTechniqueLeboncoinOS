//
// Created by Marius Cotfas
// 
//


import Combine
import UIKit

final class ClassifiedAddCollectionViewCell: UICollectionViewCell {
    private let viewModel = ClassifiedAddCollectionViewModelCell()
    
    private var cancellables: Set<AnyCancellable> = []
    private var imageTask: Task<(), Never>?
    private var uiModel: ClassifiedAddUIModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        listenStateChanges()
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
    
    @objc private func loadImage() {
        imageTask?.cancel()
        imageTask = Task {
            await viewModel.getImageData(for: uiModel?.imageSmallURLString)
        }
    }
    
    private func listenStateChanges() {
        viewModel.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
            guard let self else { return }
                
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
    
    private lazy var isUrgentView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .red
        return imageView
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.color = .yellow
        return view
    }()
    
    private lazy var reloadImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "goforward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .darkGray
        imageView.clipsToBounds = true
        
        imageView.addSubview(isUrgentView)
        NSLayoutConstraint.activate([
            isUrgentView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            isUrgentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ])
        
        imageView.addSubview(loadingIndicatorView)
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        imageView.addSubview(reloadImageButton)
        NSLayoutConstraint.activate([
            reloadImageButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            reloadImageButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        
        return label
    }()
    
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
}
