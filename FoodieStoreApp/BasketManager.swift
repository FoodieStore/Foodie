//
//  BasketManager.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 30.04.2025.
//

import Foundation

struct BasketItem {
    let product: Product
    var quantity: Int
}

class BasketManager {
    static let shared = BasketManager()
    
    private init() {}
    
    var items: [BasketItem] = []
    
    func addToBasket(product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.isim == product.isim }) {
            items[index].quantity += quantity
        } else {
            items.append(BasketItem(product: product, quantity: quantity))
        }
    }
    
    func removeFromBasket(productName: String) {
        items.removeAll { $0.product.isim == productName }
    }
    
    func clearBasket() {
        items.removeAll()
    }
    
    func calculateTotalPrice() -> Double {
        var total: Double = 0

        for item in items {
            let fiyatStr = item.product.fiyat.replacingOccurrences(of: "₺", with: "").trimmingCharacters(in: .whitespaces)
            if let birimFiyat = Double(fiyatStr) {
                total += birimFiyat * Double(item.quantity)
            }
        }

        return total
    }

}
