//
//  BookmarkCollectionViewCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import UIKit
import RxSwift

final class BookmarkCollectionViewCell: UICollectionViewCell {
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, bookmarkButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private lazy var labelStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return stackView
    }()
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .label
        
        return label
    }()
    private let addressLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    private(set) lazy var bookmarkButton = {
        let button = UIButton()
        button.setImage(defaultStarImage, for: .normal)
        button.tintColor = .systemYellow
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    private let defaultStarImage = {
        let image = UIImage(systemName: "star")
        
        return image
    }()
    private let filledStarImage = {
        let image = UIImage(systemName: "star.fill")
        
        return image
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
    
    func toggleBookmarkButtonImage(shouldFiilStar: Bool) {
        if shouldFiilStar {
            bookmarkButton.setImage(filledStarImage, for: .normal)
            return
        }
        
        bookmarkButton.setImage(defaultStarImage, for: .normal)
    }
    
    func configure(title: String, address: String) {
        titleLabel.text = title
        addressLabel.text = address
    }
}
