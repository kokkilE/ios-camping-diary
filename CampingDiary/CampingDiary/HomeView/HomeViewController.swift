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
    }
    
    private let searchMapView = SearchMapView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
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
        applySnapshot()
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
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 1.0),
            
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
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier)
    }
    
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch Section.allCases[sectionIndex] {
            case .Diary:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            case .Bookmark:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            if indexPath.section == Section.Diary.rawValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryCollectionViewCell
                
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
    
    private func applySnapshot() {
        Observable
            .combineLatest(viewModel.getObservableDiary(),
                           viewModel.getObservableBookmarks())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diaryList, bookmarkList in
                var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
                snapshot.appendSections([.Diary, .Bookmark])
                snapshot.appendItems(diaryList, toSection: .Diary)
                snapshot.appendItems(bookmarkList, toSection: .Bookmark)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }
}
