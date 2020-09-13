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
    let pin = UIImageView()
    let price = UILabel()
    let size = UILabel()
    let adress = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        price.textColor = #colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1)

        if let font = UIFont(name: "Montserrat-Medium", size: 12) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title2)
            size.font = fontMetrics.scaledFont(for: font)
        }
        size.textColor = .secondaryLabel

        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title3)
            adress.font = fontMetrics.scaledFont(for: font)
        }
        adress.textColor = .secondaryLabel
        
        let innerStackView = UIStackView(arrangedSubviews: [pin, adress])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .fillProportionally
  
        let stackView = UIStackView(arrangedSubviews: [imageView, price, size, innerStackView])
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
        stackView.setCustomSpacing(4, after: price)
        stackView.setCustomSpacing(10, after: size)
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
