//
//  DiaryCollectionViewCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import UIKit
import RxSwift

final class DiaryCollectionViewCell: UICollectionViewCell {
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, imageView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
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
        contentView.addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(title: String, image: UIImage?) {
        titleLabel.text = title
        imageView.image = image
    }
}
