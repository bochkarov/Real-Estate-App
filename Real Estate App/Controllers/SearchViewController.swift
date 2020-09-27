//
//  SearchViewController.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 06/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

enum TagType {
    case luxury
    case schools
}

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    let sections = Bundle.main.decode([Section].self, from: "searchResults.json")
    var collectionView: UICollectionView!
    
    
//    var dataSource: UICollectionViewDiffableDataSource<Section, Apartment>?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    var pickedTegs: [TagType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print(sections)
        sections.map { (filters) in
            filters.filters.map { (button) in
                print(button.tagName)
            }
        }
        
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
        createDataSource()
        reloadData()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        print("viewDidAppear")

//        UIView.animate(withDuration: 5, delay: 5, options: .autoreverse, animations: {
//            self.view.alpha = 1
//        })
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
    
    
    
    
    func createDataSource() {
         dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable> (collectionView: collectionView) { collectionView, indexPath, item in
            
            if let apartment = item as? Apartment {
//                switch self.sections[indexPath.section].type {
//                      case "filterButtons":
//                          return self.configure(FilterButtonsCell.self, with: apartment, for: indexPath)
//                      default:
                          return self.configure(SearchResultsCell.self, with: apartment, for: indexPath)
//                      }
            }
            if let filterButton = item as? FilterButton {
                
                return self.configureFilter(FilterButtonsCell.self, with: filterButton, for: indexPath)
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterButtonsCell.reuseIdentifier, for: indexPath)
            
//                return cell
//
                
            }
            
            fatalError()
        }

        
        
        
//        dataSource = UICollectionViewDiffableDataSource<Section,Apartment>(collectionView: collectionView) { collectionView, indexPath, apartment in
//            switch self.sections[indexPath.section].type {
//            case "filterButtons":
//                return self.configure(FilterButtonsCell.self, with: apartment, for: indexPath)
//            default:
//                return self.configure(SearchResultsCell.self, with: apartment, for: indexPath)
//            }
//        }
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
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Apartment>()
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
            snapshot.appendItems(section.filters, toSection: section)
            
//            var filteredItems: [String] = []
//            if pickedTegs.containt(section.items[3].tag) {
//                filteredItems.append(section.items[3])
//            }
//            snapshot.appendItems(filteredItems, toSection: section)
        }
        
        dataSource?.apply(snapshot)
        
    }
    
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.24), heightDimension: .fractionalHeight(0.1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
              let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

    
    
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 16, trailing: 0)
        return layoutSection
    }
    
    
}

//extension SearchViewController: SearchVCDelegate {
//    func buttonPressed(tag: String) {
//        // 1. String -> TagType
//        // 2. pickedTegs.append(tag)
//        // 3. reloadData()
//    }
//}
