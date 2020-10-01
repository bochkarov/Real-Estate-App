//
//  SelfConfiguringCell.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 04/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with apartment: Apartment)
}
