//
//  ProductStruct.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import Foundation

// MARK: - WelcomeElement
struct Product: Codable {
    let isim, fiyat, turkceisim: String
    let ozellikler: [String]
    let aciklama, gorsel: String
}
