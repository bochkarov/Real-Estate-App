//
//  SearchViewController.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 06/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    let sections = Bundle.main.decode([Section].self, from: "searchResults.json")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    var currentFilter: String? = nil
    var itemsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.filters, toSection: section)
            if currentFilter != nil {
                let items = section.items
                let filterdItems = items.filter { $0.tag.contains(currentFilter!) }
                snapshot.appendItems(filterdItems, toSection: section)
                itemsCount = filterdItems.count
                
            } else {
                snapshot.appendItems(section.items, toSection: section)
                itemsCount = section.items.count
            }
        }
        dataSource?.apply(snapshot)
        collectionView.reloadData()
    }
    
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with apartment: Apartment, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: apartment)
        return cell
    }
    
    func configureFilter<T: SelfConfiguringFilterButtonCell>(_ cellType: T.Type, with filterButton: FilterButton, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: filterButton)
        return cell
    }
    
    // MARK: - Setup View
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(FilterButtonsCell.self, forCellWithReuseIdentifier: FilterButtonsCell.reuseIdentifier)
        collectionView.register(SearchVCSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchVCSectionHeader.reuseIdentifier)
        collectionView.register(SearchResultsCell.self, forCellWithReuseIdentifier: SearchResultsCell.reuseIdentifier)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - DataSource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable> (collectionView: collectionView) { collectionView, indexPath, item in
            
            if let apartment = item as? Apartment {
                return self.configure(SearchResultsCell.self, with: apartment, for: indexPath)
            }
            if let filterButton = item as? FilterButton {
                
                let cell = self.configureFilter(FilterButtonsCell.self, with: filterButton, for: indexPath)
                cell.delegate = self
                return cell
            }
            fatalError()
        }
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchVCSectionHeader.reuseIdentifier, for: indexPath) as? SearchVCSectionHeader else {
                return nil
            }
            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
            if section.title.isEmpty { return nil }
            
            if let counter = self?.itemsCount {
                sectionHeader.title.text = "\(counter) Results Found"
            }
            sectionHeader.button.addTarget(self, action: #selector(self?.sortButtonPressed), for: .touchUpInside)
            return sectionHeader
        }
        
        
    }
    @objc func sortButtonPressed() {
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Newest First", style: .default , handler:{ (UIAlertAction)in
            print("User click Newest First")
        }))

        alert.addAction(UIAlertAction(title: "Oldest First", style: .default , handler:{ (UIAlertAction)in
            print("User click Oldest First")
        }))

        alert.addAction(UIAlertAction(title: "Featured", style: .default , handler:{ (UIAlertAction)in
            print("User click Featured")
        }))

        alert.addAction(UIAlertAction(title: "Best Rated", style: .default, handler:{ (UIAlertAction)in
            print("User click Best Rated")
        }))

        alert.addAction(UIAlertAction(title: "Only near me", style: .default, handler:{ (UIAlertAction)in
            print("User click Only near me")
        }))

        self.present(alert, animated: true, completion: nil)
        print("Hello")
    }
    
    
    // MARK: - Layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            switch section.type {
            case "filterButtons":
                return self.createFilterButtonsSections(using: section)
            default:
                return self.createSearchResultSection(using: section)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    func createSearchResultSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.93))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    func createFilterButtonsSections(using section: Section) -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize.init(
            widthDimension: .estimated(100),
            heightDimension: .absolute(32)
        )
        let section = NSCollectionLayoutSection(group:
                                                    .horizontal(
                                                        layoutSize: layoutSize,
                                                        subitems: [.init(layoutSize: layoutSize)]
                                                    )
        )
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 26, trailing: 10)
        return section
    }
}

// MARK: - FilterButtonsCellDelegate
extension SearchViewController: FilterButtonsCellDelegate {

    func buttonPressed(filter: String) {
        if currentFilter == filter {
            currentFilter = nil
            reloadData()
        } else {
            currentFilter = filter
            reloadData()
        }
    }
}


