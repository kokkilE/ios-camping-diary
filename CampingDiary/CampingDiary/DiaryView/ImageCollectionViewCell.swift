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
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return imageView
    }()
    
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
    }
    
    private func layout() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
