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
        
        return imageView
    }()
    let deleteButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
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
            imageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -4),
            
            deleteButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            deleteButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
