//
//  HomeViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/5/23.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: enum for collectionView section
extension HomeViewController {
    enum Section: Int, CaseIterable {
        case Diary
        case Bookmark
        
        var description: String {
            switch self {
            case .Diary:
                return "캠핑 일지"
            case .Bookmark:
                return "내 캠핑장"
            }
        }
    }
}

final class HomeViewController: UIViewController {
// MARK: define properties
    private let searchMapView = SearchMapView()
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier)
        collectionView.register(DiaryCollectionViewHeaderCell.self, forCellWithReuseIdentifier: DiaryCollectionViewHeaderCell.reuseIdentifier)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable?>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable?>()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
}

// MARK: methods
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        bindToSearchMapView()
        setupDataSource()
        setupDataSourceHeaderView()
        configureSnapshotSections()
        bindToCellData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchMapView)
        view.addSubview(collectionView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchMapView.topAnchor.constraint(equalTo: safe.topAnchor),
            searchMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 0.8),
            
            collectionView.topAnchor.constraint(equalTo: searchMapView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12)
        ])
    }
    
    private func bindToSearchMapView() {
        searchMapView.searchButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                let searchKeyword = searchMapView.getText()
                let searchMapViewController = SearchMapViewController(keyword: searchKeyword)
                
                navigationController?.pushViewController(searchMapViewController, animated: false)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: configure collectionview
extension HomeViewController {
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var section: NSCollectionLayoutSection
            
            switch Section.allCases[sectionIndex] {
            case .Diary:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
            case .Bookmark:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
            }
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: SectionTitleHeaderView.reuseIdentifier, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable?>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            if indexPath.section == Section.Diary.rawValue {
                if let item = item as? Diary,
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryCollectionViewCell {
                    cell.configure(locationTitle: item.location.title.toLocationTitle(),
                                   editDate: DateFormatter.getString(date: item.editDate))
                    
                    cell.disposeBag = DisposeBag()
                    cell.longPressGesture
                        .bind { [weak self] _ in
                            guard let self else { return }
                            
                            let actionSheet = AlertManager.getSingleActionSheet(sourceView: cell, actionName: "삭제하기") { [weak self] _ in
                                guard let self else { return }
                                
                                viewModel.removeDiary(item)
                            }
                            
                            present(actionSheet, animated: true)
                        }
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewHeaderCell.reuseIdentifier, for: indexPath) as? DiaryCollectionViewHeaderCell {
                    cell.disposeBag = DisposeBag()
                    cell.addButton.rx.tap
                        .bind { [weak self] in
                            guard let self else { return }
                            
                            let diaryViewController = DiaryViewController()
                            
                            navigationController?.pushViewController(diaryViewController, animated: true)
                        }
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            }
            
            if indexPath.section == Section.Bookmark.rawValue {
                if let item = item as? Location,
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier, for: indexPath) as? BookmarkCollectionViewCell {
                    cell.configure(title: item.title.toLocationTitle(),
                                   address: item.roadAddress)
                    
                    cell.disposeBag = DisposeBag()
                    cell.deleteButton.rx.tap
                        .bind { [weak self] in
                            guard let self else { return }
                            
                            viewModel.removeBookmark(item)
                        }
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            }
            
            return UICollectionViewCell()
        }
    }
    
    private func setupDataSourceHeaderView() {
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <SectionTitleHeaderView>(elementKind: SectionTitleHeaderView.reuseIdentifier) { supplementaryView, string, indexPath in
            if indexPath.section == Section.Diary.rawValue {
                supplementaryView.configure(title: Section.Diary.description)
                
                return
            }
            
            if indexPath.section == Section.Bookmark.rawValue {
                supplementaryView.configure(title: Section.Bookmark.description)
                
                return
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
        }
    }
    
    private func configureSnapshotSections() {
        snapshot.appendSections([.Diary])
        snapshot.appendSections([.Bookmark])
    }
    
    private func bindToCellData() {
        viewModel
            .getObservableDiary()
            .bind { [weak self] diaries in
                guard let self else { return }
                
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .Diary))
                snapshot.appendItems(diaries, toSection: .Diary)
                dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .getObservableBookmarks()
            .bind { [weak self] bookmarks in
                guard let self else { return }
                
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .Bookmark))
                snapshot.appendItems(bookmarks, toSection: .Bookmark)
                dataSource?.apply(snapshot, animatingDifferences: true)
                
                searchMapView.configureBookmarkMarkers(locations: bookmarks)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Section.Bookmark.rawValue {
            searchMapView.focusMarker(at: indexPath.item)
        }
    }
}
