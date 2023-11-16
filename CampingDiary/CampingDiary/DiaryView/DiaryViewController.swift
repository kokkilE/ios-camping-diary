//
//  DiaryViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/14/23.
//

import UIKit
import RxSwift
import PhotosUI

final class DiaryViewController: UIViewController {
// MARK: define properties
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationStackView, campSiteStackView, visitDateStackView, imageCollectionView, contentStackView])
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
    
    private lazy var imageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable?>?
    private let viewModel = DiaryViewModel()
    private let disposeBag = DisposeBag()
}

// MARK: method
extension DiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        configureButtonAction()
        setupCollectionView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
    }
    
    private func addSubviews() {
        view.addSubview(mainStackView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
            
            imageCollectionView.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func configureButtonAction() {
        searchButton.rx.tap
            .bind { [weak self] in
                let locationSelectionViewContoller = LocationSelectionViewContoller()
                
                self?.present(locationSelectionViewContoller, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: configure collectionview
extension DiaryViewController {
    enum Section {
        case image
    }
    
    private func setupCollectionView() {
        registerCell()
        setupDataSource()
        bindToCellData()
    }
    
    private func registerCell() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        imageCollectionView.register(ImageCollectionViewHeaderCell.self, forCellWithReuseIdentifier: ImageCollectionViewHeaderCell.reuseIdentifier)
    }
    
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable?>(collectionView: imageCollectionView) { [weak self] collectionView, indexPath, image in
            guard let self else { return UICollectionViewCell() }
            
            if let image = image as? UIImage {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
                cell?.configure(image: image)
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewHeaderCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewHeaderCell
            
            cell?.addButton.rx.tap
                .bind { [weak self] in
                    self?.presentImagePicker()
                }
                .disposed(by: disposeBag)
            
            return cell
        }
    }
    
    private func bindToCellData() {
        viewModel
            .getCellData()
            .bind { [weak self] images in
                var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable?>()
                snapshot.appendSections([.image])
                snapshot.appendItems(images, toSection: .image)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: present PHPickerViewController
extension DiaryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                
                self?.viewModel.add(image)
            }
        }
        
        dismiss(animated: true)
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
}
