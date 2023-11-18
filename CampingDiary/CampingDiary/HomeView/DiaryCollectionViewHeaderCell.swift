//
//  DiaryGroupHeaderCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/13/23.
//

import UIKit
import RxSwift

class DiaryCollectionViewHeaderCell: UICollectionViewCell {
    let addButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
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
        addSubview(addButton)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.5),
            addButton.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.5),
            addButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor)
        ])
    }
}
