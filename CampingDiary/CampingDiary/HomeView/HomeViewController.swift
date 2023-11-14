//
//  HomeViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/5/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
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
    
    private let searchMapView = SearchMapView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable?>?
    
    private let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupSearchMapView()
        setupCollectionView()
        setupDataSource()
        setupDataSourceHeaderView()
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
    
    private func setupSearchMapView() {
        searchMapView.configureSearchButtonAction { [weak self] in
            guard let self else { return }
            
            let searchKeyword = searchMapView.getText()
            let searchMapViewController = SearchMapViewController(keyword: searchKeyword)
            
            navigationController?.pushViewController(searchMapViewController, animated: false)
        }
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier)
        collectionView.register(DiaryCollectionViewHeaderCell.self, forCellWithReuseIdentifier: DiaryCollectionViewHeaderCell.reuseIdentifier)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier)
    }
   
}

// MARK: configure modern collectionview
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
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable?>(collectionView: collectionView) { collectionView, indexPath, item in
            if indexPath.section == Section.Diary.rawValue {
                // dummy data
                if let item = item as? Diary {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryCollectionViewCell
                    
                    cell?.configure(title: item.content,
                                    image: UIImage(systemName: "star"))
                    
                    return cell
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewHeaderCell.reuseIdentifier, for: indexPath) as? DiaryCollectionViewHeaderCell
                
                return cell
            }
            
            if indexPath.section == Section.Bookmark.rawValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier, for: indexPath) as? BookmarkCollectionViewCell
                if let item = item as? Location {
                    cell?.configure(title: item.title.toLocationTitle(),
                                    address: item.roadAddress)
                }
                
                return cell
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
    
    private func bindToCellData() {
        Observable
            .combineLatest(viewModel.getObservableDiary(),
                           viewModel.getObservableBookmarks())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diaryList, bookmarkList in
                var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable?>()
                snapshot.appendSections([.Diary, .Bookmark])
                snapshot.appendItems(diaryList, toSection: .Diary)
                snapshot.appendItems(bookmarkList, toSection: .Bookmark)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }
}
