//
//  CategoryCollectionViewCell.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 26.04.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           
           titleLabel.textAlignment = .center
           titleLabel.textColor = UIColor(red: 111/255.0, green: 145/255.0, blue: 59/255.0, alpha: 1.0)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           
           stackView.axis = .vertical
           stackView.alignment = .center
           stackView.distribution = .fill
           stackView.spacing = 8
           stackView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
               stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 4),
               stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -4),
               stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
           ])
           
           NSLayoutConstraint.activate([
               imageView.widthAnchor.constraint(equalToConstant: 75),
               imageView.heightAnchor.constraint(equalToConstant: 75)
           ])
  
    }
    

    
}
