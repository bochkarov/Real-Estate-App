//
//  Section.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 04/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import Foundation
struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let items: [Apartment]
    let filters: [FilterButton]
}
