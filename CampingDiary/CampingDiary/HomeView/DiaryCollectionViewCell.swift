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
        let stackView = UIStackView(arrangedSubviews: [locationLabel, editDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let locationLabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.70
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    private let editDateLabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.70
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 0.6
        layer.borderColor = UIColor.label.cgColor
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
    
    func configure(locationTitle: String, editDate: String) {
        locationLabel.text = locationTitle
        editDateLabel.text = "수정된 날짜: \(editDate)"
    }
}
