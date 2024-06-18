//
// Created by Marius Cotfas
// 
//


import UIKit

final class ListingLoadedCollectionViewController: UICollectionViewController {
    enum Constants {
        static let classifiedAddCellIdentifier = "classifiedAddCellIdentifier"
    }
    
    var classifiedAddsUIModels: [ClassifiedAddUIModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let onClassifiedAddSelected: (ClassifiedAddUIModel) -> Void
    
    init(onClassifiedAddSelected: @escaping (ClassifiedAddUIModel) -> Void) {
        self.onClassifiedAddSelected = onClassifiedAddSelected
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension ListingLoadedCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureLayout()
    }
    
    private func registerCells() {
        collectionView.register(
            ClassifiedAddCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.classifiedAddCellIdentifier
        )
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .lightGray
    }
    
    private func configureLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let itemsPerRow: CGFloat = 2
            let padding: CGFloat = 8
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth = (view.bounds.width - totalPadding) / itemsPerRow
            
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ListingLoadedCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classifiedAddsUIModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.classifiedAddCellIdentifier,
            for: indexPath
        ) as! ClassifiedAddCollectionViewCell
        
        cell.configure(with: classifiedAddsUIModels[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uiModel = classifiedAddsUIModels[indexPath.item]
        onClassifiedAddSelected(uiModel)
    }
}

