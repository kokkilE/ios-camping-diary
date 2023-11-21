//
//  ImageCollectionViewCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/14/23.
//

import UIKit
import RxSwift

final class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let deleteButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
    }
    
    private func layout() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safe.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 8)
        ])
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
