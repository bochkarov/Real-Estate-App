//
//  JustInCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 04/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class JustInCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "JustInCell"
    
    let imageView = UIImageView()
    let price = UILabel()
    let size = UILabel()
    let adress = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        price.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        price.textColor = .systemBlue
        
        size.font = UIFont.preferredFont(forTextStyle: .title2)
        size.textColor = .label
        
        adress.font = UIFont.preferredFont(forTextStyle: .title2)
        adress.textColor = .secondaryLabel
        
//        if let font = UIFont(name: "Montserrat-SemiBold", size: 16) {
//            let fontMetrics = UIFontMetrics(forTextStyle: .headline)
//            price.font = fontMetrics.scaledFont(for: font)
//        }
//        price.textColor = .label
//
//        if let font = UIFont(name: "Montserrat-Medium", size: 12) {
//            let fontMetrics = UIFontMetrics(forTextStyle: .title2)
//            size.font = fontMetrics.scaledFont(for: font)
//        }
//        size.textColor = .secondaryLabel
//
//        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
//            let fontMetrics = UIFontMetrics(forTextStyle: .title3)
//            adress.font = fontMetrics.scaledFont(for: font)
//        }
//        adress.textColor = .secondaryLabel
        
        let stackView = UIStackView(arrangedSubviews: [imageView, price, size, adress])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.setCustomSpacing(10, after: imageView)
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
