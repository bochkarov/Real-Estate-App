//
//  SectionHeader.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 05/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    let title = UILabel()
    let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        if let font = UIFont(name: "Montserrat-Bold", size: 20) {
//            let fontMetrics = UIFontMetrics(forTextStyle: .headline)
            title.font = font
            title.textColor = #colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1)
        }
        
        if let font = UIFont(name: "Montserrat-SemiBold", size: 12) {
            let fontMetrics = UIFontMetrics(forTextStyle: .title1)
            button.titleLabel?.font = fontMetrics.scaledFont(for: font)
        }
        
        button.setTitle("View All", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6784313725, blue: 0.6784313725, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [title, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20
            )
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
