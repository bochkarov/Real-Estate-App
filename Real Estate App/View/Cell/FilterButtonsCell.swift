//
//  FilterButtonsCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 13/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

protocol SelfConfiguringFilterButtonCell {

    
    static var reuseIdentifier: String { get }
    func configure(with filterButton: FilterButton)
}


//class FilterButtonCell: UICollectionViewCell {
//    
//    let luxButton = UIButton(type: .custom)
//    
//    weak var delegate: SearchVCDelegate?
//    
//    var something: Something? = nil
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        // custize
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with something: Something) {
//        self.something = something
//        luxButton.setTitle(something.tagName, for: .normal)
//        luxButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//    }
//    
//    @objc func buttonPressed() {
//        delegate.buttonPressed(tag: something.tagName)
//    }
//    
//}

class FilterButtonsCell: UICollectionViewCell, SelfConfiguringFilterButtonCell {
 
    
    static var reuseIdentifier: String = "FilterButtonCell"
    
    let filtButton = UIButton(type: .custom)
    var filterButtonModel: FilterButton? = nil
    weak var delegate: FilterButtonsCellDelegate!
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        filtButton.backgroundColor = .clear
        filtButton.layer.cornerRadius = 5
        filtButton.layer.borderWidth = 1
        filtButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)

        if let font = UIFont(name: "Montserrat-SemiBold", size: 12) {
            filtButton.titleLabel?.font = font
        }
        filtButton.setTitle(filterButtonModel?.tagName, for: .normal)
        
//        for button in buttons {
//            button.backgroundColor = .clear
//            button.layer.cornerRadius = 5
//            button.layer.borderWidth = 1
//            button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
//
//            if let font = UIFont(name: "Montserrat-SemiBold", size: 12) {
//                button.titleLabel?.font = font
//            }
//        }
//        filtButton.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//        luxButton.layer.borderColor = #colorLiteral(red: 0.1411764706, green: 0.7333333333, blue: 0.4196078431, alpha: 1)
//        schoolButton.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.5882352941, blue: 1, alpha: 1)
//        securityButton.layer.borderColor = #colorLiteral(red: 0.3725490196, green: 0.4431372549, blue: 0.7607843137, alpha: 1)
        
        
//        luxButton.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.7333333333, blue: 0.4196078431, alpha: 1), for: .normal)
//        schoolButton.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.5882352941, blue: 1, alpha: 1), for: .normal)
//        securityButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.4431372549, blue: 0.7607843137, alpha: 1), for: .normal)
        
//        let stackView = UIStackView(arrangedSubviews: [distButton, luxButton, schoolButton, securityButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        contentView.addSubview(stackView)
        contentView.addSubview(filtButton)
        
        filtButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filtButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filtButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            filtButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            filtButton.topAnchor.constraint(equalTo: topAnchor),
//            filtButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            filtButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        
        
        
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//        stackView.spacing = 20
    }
    
    
    func configure(with filterButton: FilterButton) {
        
        
        filtButton.setTitle(filterButton.tagName, for: .normal)
        
        filtButton.layer.borderColor = hexStringToUIColor(hex: filterButton.color).cgColor
        filtButton.setTitleColor(hexStringToUIColor(hex: filterButton.color), for: .normal)
        filtButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        
        print("Button pressed")
        
        guard let tag = filtButton.titleLabel?.text else {
            return
        }
        
        self.delegate?.buttonPressed(tag: tag)
      }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    
}


