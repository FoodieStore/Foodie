//
//  ProductCollectionViewCell.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        productLabel.textAlignment = .center
        productLabel.textColor = UIColor(red: 111/255.0, green: 145/255.0, blue: 59/255.0, alpha: 1.0)
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView ayarları
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 60),
            productImage.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
