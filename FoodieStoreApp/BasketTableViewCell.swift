//
//  BasketTableViewCell.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 30.04.2025.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with item: BasketItem) {
        productNameLabel.text = item.product.turkceisim
        quantityLabel.text = "\(item.quantity) adet"
        
        let fiyatStr = item.product.fiyat.replacingOccurrences(of: "₺", with: "").trimmingCharacters(in: .whitespaces)
        if let birimFiyat = Double(fiyatStr) {
            let toplamFiyat = birimFiyat * Double(item.quantity)
            productPriceLabel.text = String(format: "%.2f ₺", toplamFiyat)
        } else {
            productPriceLabel.text = item.product.fiyat
        }
        
        if let image = UIImage(named: item.product.gorsel) {
            productImageView.image = image
        }
        
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
    }


}
