//
//  DiaryViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/14/23.
//

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryEditView = DiaryEditView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
    }
    
    private func addSubviews() {
        view.addSubview(diaryEditView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            diaryEditView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            diaryEditView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            diaryEditView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            diaryEditView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12)
        ])
    }
}
