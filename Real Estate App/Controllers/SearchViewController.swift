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
    var dataSource: UICollectionViewDiffableDataSource<Section, Apartment>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(SearchVCSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchVCSectionHeader.reuseIdentifier)
        
        collectionView.register(SearchResultsCell.self, forCellWithReuseIdentifier: SearchResultsCell.reuseIdentifier)
        createDataSource()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    private func setupNavigationBar() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by Location, Area or Pin Code"
        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            let fontMetrics = UIFontMetrics(forTextStyle: .headline)
            searchController.searchBar.searchTextField.font = fontMetrics.scaledFont(for: font)
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with apartment: Apartment, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: apartment)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Apartment>(collectionView: collectionView) { collectionView, indexPath, apartment in
            switch self.sections[indexPath.section].type {
            default:
                return self.configure(SearchResultsCell.self, with: apartment, for: indexPath)
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self]
                  collectionView, kind, indexPath in
                  guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchVCSectionHeader.reuseIdentifier, for: indexPath) as? SearchVCSectionHeader else {
                      return nil
                  }
                  
                  guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                  guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
                  if section.title.isEmpty { return nil }
                  
                  sectionHeader.title.text = section.title
                  return sectionHeader
              }
    }
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Apartment>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
        
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let section = self.sections[sectionIndex]
            switch section.type {
                
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
         layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
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
    
    
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
