//
//  SearchResultsCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 06/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class SearchResultsCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "SearchResultsCell"
    
    let imageView = UIImageView()
    let pin = UIImageView()
    let price = UILabel()
    let size = UILabel()
    let adress = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        pin.image = UIImage(named: "pin")
        pin.clipsToBounds = true
        pin.contentMode = .left
        
        if let font = UIFont(name: "Montserrat-SemiBold", size: 16) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title1)
            price.font = fontMetrics.scaledFont(for: font)
        }
        price.textColor = #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        
        if let font = UIFont(name: "Montserrat-Medium", size: 12) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title2)
            size.font = fontMetrics.scaledFont(for: font)
        }
        size.textColor = .black
        
        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title3)
            adress.font = fontMetrics.scaledFont(for: font)
        }
        adress.textColor = .secondaryLabel
        
        let adressStackView = UIStackView(arrangedSubviews: [pin, adress])
        adressStackView.axis = .horizontal
        adressStackView.distribution = .fillProportionally
        
        let adressSizeStackView = UIStackView(arrangedSubviews: [size, adressStackView])
        adressSizeStackView.axis = .vertical
        adressSizeStackView.distribution = .fillProportionally
        adressSizeStackView.spacing = 10
        
        let adressSizePriceStackView = UIStackView(arrangedSubviews: [adressSizeStackView, price])
        adressSizePriceStackView.axis = .horizontal
        adressSizePriceStackView.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [imageView,adressSizePriceStackView])
          stackView.translatesAutoresizingMaskIntoConstraints = false
          stackView.axis = .vertical
          contentView.addSubview(stackView)
          NSLayoutConstraint.activate([
            
              stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
              stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
          ])
        stackView.setCustomSpacing(15, after: imageView)
    }
    
    func configure(with apartment: Apartment) {
        imageView.image = UIImage(named: apartment.image)
        price.text = apartment.price
        size.text = apartment.size
        adress.text = apartment.adress
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
