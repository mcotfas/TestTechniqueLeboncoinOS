//
// Created by Marius Cotfas
// 
//
    

import Foundation
import UIKit

enum ViewsFactory {
    
    static func makeImageView(
        isUrgentView: UIView,
        loadingIndicatorView: UIView,
        reloadImageButton: UIView
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.tintColor = .lightGray
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
    }
        
    static func makeLoadingIndicatorView () -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.color = .black
        return view
    }
    
    static func makeReloadButton(
        reloadAction: @escaping () -> Void
    ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 48)
        ])

        button.setImage(UIImage(systemName: "goforward"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        
        let closureWrapper = ClosureWrapper(action: reloadAction)
        button.addTarget(self, action: #selector(closureWrapper.invoke), for: .touchUpInside)
        
        return button
    }
    
    static func makeIsUrgentView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .red
        return imageView
    }
    
    static func makeCategoryLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }
    
    static func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }
    
    static func makeTitleLabel(lines: Int) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = lines
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)        
        return label
    }
    
    static func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }
    
    static func makeSiretLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }
}

// MARK: Tools

final class ClosureWrapper {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    @objc func invoke() {
        action()
    }
}
