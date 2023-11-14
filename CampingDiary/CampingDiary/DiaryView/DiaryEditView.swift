//
//  DiaryEditView.swift
//  CampingDiary
//
//  Created by 조향래 on 11/14/23.
//

import UIKit

final class DiaryEditView: UIView {
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationStackView, campSiteStackView, visitDateStackView, contentStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var locationStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationTitleLabel, locationLabel, searchButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 10.0
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    private let locationTitleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "캠핑장"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    private let locationLabel = {
        let label = UILabel()
        label.textColor = .placeholderText
        label.text = "지도에서 캠핑장을 검색하세요."
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let searchButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .systemBlue
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    private lazy var campSiteStackView = {
        let stackView = UIStackView(arrangedSubviews: [campSiteTitleLabel, campSiteTextField])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 10.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return stackView
    }()
    private let campSiteTitleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "사이트"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    private let campSiteTextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.placeholder = "사이트 번호를 입력하세요."
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }()
    
    private lazy var visitDateStackView = {
        let stackView = UIStackView(arrangedSubviews: [visitDateTitleLabel, visitDateLabel, dateSelectButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 10.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return stackView
    }()
    private let visitDateTitleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "방문일"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    private let visitDateLabel = {
        let label = UILabel()
        label.textColor = .placeholderText
        label.text = "방문 일자를 선택하세요."
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let dateSelectButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .systemBlue
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    private lazy var contentStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentTitleLabel, contentTextView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return stackView
    }()
    private let contentTitleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "일지"
        label.font = .preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    private let contentTextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryEditView {
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
