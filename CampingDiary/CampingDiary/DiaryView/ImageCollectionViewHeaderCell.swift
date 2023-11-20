//
//  ImageCollectionViewHeaderCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/14/23.
//

import UIKit
import RxSwift

class ImageCollectionViewHeaderCell: UICollectionViewCell {
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), addButton, countLabel, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    let addButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    private let countLabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = contentView.safeAreaLayoutGuide
        let imageHeight = UIFont.preferredFont(forTextStyle: .body).pointSize * 2
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            
            addButton.widthAnchor.constraint(equalToConstant: imageHeight),
            addButton.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
    
    func configure(_ text: String) {
        countLabel.text = text
    }
}
