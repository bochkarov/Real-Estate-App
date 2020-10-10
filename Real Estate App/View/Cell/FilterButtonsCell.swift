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
        filtButton.frame.size = contentView.bounds.size
        filtButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let font = UIFont(name: "Montserrat-SemiBold", size: 12) {
            filtButton.titleLabel?.font = font
        }
        filtButton.setTitle(filterButtonModel?.tagName, for: .normal)
        contentView.addSubview(filtButton)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: filtButton.sizeThatFits(size).width + 4, height: 32)

    }
    func configure(with filterButton: FilterButton) {
        filtButton.setTitle(filterButton.tagName, for: .normal)
        filtButton.layer.borderColor = hexStringToUIColor(hex: filterButton.color).cgColor
        filtButton.setTitleColor(hexStringToUIColor(hex: filterButton.color), for: .normal)
        filtButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        guard let tag = filtButton.titleLabel?.text else {
            return
        }
        self.delegate?.buttonPressed(filter: tag)
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


