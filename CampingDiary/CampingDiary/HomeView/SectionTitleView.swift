//
//  SectionTitleView.swift
//  CampingDiary
//
//  Created by 조향래 on 11/13/23.
//

import UIKit

class SectionTitleView: UICollectionReusableView, ReuseIdentifying {
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubviews() {
        addSubview(label)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(title: String) {
        label.text = title
    }
}
