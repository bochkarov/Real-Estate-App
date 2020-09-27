//
//  Apartment.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 04/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import Foundation

struct Apartment: Decodable, Hashable {
    let id: Int
    let price: String
    let size: String
    let adress: String
    let image: String
    let tag: String
}
