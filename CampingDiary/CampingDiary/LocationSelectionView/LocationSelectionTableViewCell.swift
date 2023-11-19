//
//  LocationSelectionTableViewCell.swift
//  CampingDiary
//
//  Created by 조향래 on 11/16/23.
//

import UIKit

final class LocationSelectionTableViewCell: SearchMapTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureButtonImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonImage() {
        bookmarkButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        bookmarkButton.tintColor = .systemBlue
    }
}
