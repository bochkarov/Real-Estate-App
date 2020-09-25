//
//  FilterButtonsCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 13/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit


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

class FilterButtonsCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "FilterButtonsCell"
    
    let distButton = UIButton(type: .custom) // --> cell
    let luxButton = UIButton(type: .custom)
    let schoolButton = UIButton(type: .custom)
    let securityButton = UIButton(type: .custom)
    var buttons = [UIButton]()
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        buttons = [distButton, luxButton, schoolButton, securityButton]
        
        for button in buttons {
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)

            if let font = UIFont(name: "Montserrat-SemiBold", size: 12) {
                button.titleLabel?.font = font
            }
        }
        distButton.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.7921568627, alpha: 1)
        luxButton.layer.borderColor = #colorLiteral(red: 0.1411764706, green: 0.7333333333, blue: 0.4196078431, alpha: 1)
        schoolButton.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.5882352941, blue: 1, alpha: 1)
        securityButton.layer.borderColor = #colorLiteral(red: 0.3725490196, green: 0.4431372549, blue: 0.7607843137, alpha: 1)
        
        distButton.setTitleColor(#colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.7921568627, alpha: 1), for: .normal)
        luxButton.setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.7333333333, blue: 0.4196078431, alpha: 1), for: .normal)
        schoolButton.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.5882352941, blue: 1, alpha: 1), for: .normal)
        securityButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.4431372549, blue: 0.7607843137, alpha: 1), for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [distButton, luxButton, schoolButton, securityButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.spacing = 20
    }
    
    func configure(with apartment: Apartment) {
        distButton.setTitle("Within 2mi", for: .normal)
        luxButton.setTitle("Luxury", for: .normal)
        schoolButton.setTitle("Schools", for: .normal)
        securityButton.setTitle("Security", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
