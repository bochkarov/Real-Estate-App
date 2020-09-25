//
//  FilterButtonSection.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 25/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import Foundation
struct FilterButtonSection: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let filters: [FilterButton]
}
