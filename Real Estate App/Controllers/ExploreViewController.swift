//
//  ExploreViewController.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 03/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: nil, action: nil)
    
    let sections = Bundle.main.decode([Section].self, from: "realestate.json")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Apartment>?
    
    let pin = UIImageView()
    let locationLabel = UILabel()
    let locationButton = UIButton()
            let searchController = UISearchController(searchResultsController: SearchViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(JustInCell.self, forCellWithReuseIdentifier: JustInCell.reuseIdentifier)
        collectionView.register(DesignerHomesCell.self, forCellWithReuseIdentifier: DesignerHomesCell.reuseIdentifier)
        
        setupNavigationBar()
        createDataSource()
        reloadData()
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with apartment: Apartment, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: apartment)
        return cell
    }
    
    private func setupNavigationBar() {

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by Location, Area or Pin Code"
//        searchController.searchBar.showsCancelButton = false

        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            let fontMetrics = UIFontMetrics(forTextStyle: .headline)
            searchController.searchBar.searchTextField.font = fontMetrics.scaledFont(for: font)
        }
        let searchBar = searchController.searchBar
        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as! UITextField
        
        searchTextField.leftViewMode = .always
   
        

        
        
    
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage (UIImage(named: "search"), for: .bookmark, state: .normal)
        searchController.searchBar.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
        

        
        settingsBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        
        pin.image = UIImage(named: "pin20")
        pin.clipsToBounds = true
        pin.contentMode = .center
        
        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title1)
            locationLabel.font = fontMetrics.scaledFont(for: font)
        }
        locationLabel.textColor = #colorLiteral(red: 0.6941176471, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
        locationLabel.text = "Location"
        
        if let font = UIFont(name: "Montserrat-SemiBold", size: 14) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title1)
            locationButton.titleLabel?.font = fontMetrics.scaledFont(for: font)
        }
        
        locationButton.setTitle("Woodbridge ", for: .normal)
        locationButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        locationButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        locationButton.semanticContentAttribute = .forceRightToLeft
        
        let innerNavStackview = UIStackView(arrangedSubviews: [locationLabel, locationButton])
        innerNavStackview.axis = .vertical
        innerNavStackview.setCustomSpacing(4, after: locationLabel)
        
        let leftNavStackView = UIStackView(arrangedSubviews: [pin, innerNavStackview])
        leftNavStackView.setCustomSpacing(10, after: pin)
        //        leftNavStackView.distribution = .fillEqually
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftNavStackView)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Apartment>(collectionView: collectionView) { collectionView, indexPath, apartment in
            switch self.sections[indexPath.section].type {
            case "designerHomes":
                return self.configure(DesignerHomesCell.self, with: apartment, for: indexPath)
            default:
                return self.configure(JustInCell.self, with: apartment, for: indexPath)
            }
            
        }
        
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
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
            case "designerHomes":
                return self.createDesignerHomesSection(using: section)
            default:
                return self.createJustInSection(using: section)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createJustInSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(217))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        let layoutSectionHeader = createSectionHeader()
        
        
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    func createDesignerHomesSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(160))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
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


// MARK: - Actions
extension ExploreViewController {
    @objc func settingsBarButtonItemTapped() {
        print(#function)
    }
    
    @objc func groupsBarButtonItemTapped() {
        print(#function)
    }
}

// MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        navigationItem.rightBarButtonItem = .none
        navigationItem.leftBarButtonItem = .none
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
           backButton.setImage(UIImage(named: "back"), for: .normal)
           backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
           let leftView = UIView()
           leftView.addSubview(backButton)
           leftView.translatesAutoresizingMaskIntoConstraints = false
           leftView.heightAnchor.constraint(equalToConstant: 20).isActive = true
           leftView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        searchController.searchBar.searchTextField.leftView = leftView
        print(searchText)
    }
    
    @objc func backButtonTapped() {
        searchController.searchBar.searchTextField.text = ""
        searchBarCancelButtonClicked(searchController.searchBar)

    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setupNavigationBar()
    }
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         
     }

    

}
