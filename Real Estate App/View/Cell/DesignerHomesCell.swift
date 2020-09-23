//
//  DesignerHomesCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 05/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class DesignerHomesCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "DesignerHomesCell"
    let imageView = UIImageView()
    let label = UILabel()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        
        
        
        if let font = UIFont(name: "Montserrat-Medium", size: 10) {
            label.font = font
        }
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        imageView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalToConstant: 124),
            label.heightAnchor.constraint(equalToConstant: 23),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
    }
    
    
    
    func configure(with apartment: Apartment) {
        
        let blackTextColorAttribute = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let redTextColorAttribute = [NSAttributedString.Key.foregroundColor : UIColor.red]
        let startsAtAttributedString = NSMutableAttributedString(string:"Starts at ", attributes:blackTextColorAttribute)
        let priceAttributedString = NSMutableAttributedString(string:"\(apartment.price)", attributes:redTextColorAttribute)
        startsAtAttributedString.append(priceAttributedString)
        self.label.attributedText = startsAtAttributedString
        
        imageView.image = UIImage(named: apartment.image)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
