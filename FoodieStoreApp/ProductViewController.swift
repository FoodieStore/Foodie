//
//  ProductViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import UIKit

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var selectedCategoryName: String?
        var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        if let categoryName = selectedCategoryName {
                    products = loadProducts(for: categoryName)
                }
        
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 8, y: 0, width: 24, height: 24) 

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        containerView.addSubview(searchIcon)

        searchIcon.center.y = containerView.center.y

        searchTextField.leftView = containerView
        searchTextField.leftViewMode = .always
        searchTextField.placeholder = "Neye ihtiyacınız var?"

    }
    
    func loadProducts(for category: String) -> [Product] {
            var fileName = ""
            
            if category == "Meyve" {
                fileName = "meyveler"
            } else if category == "Sebze" {
                fileName = "sebzeler"
            } else if category == "Atıştırmalık" {
                fileName = "atistirmaliklar"
            }
            
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let decodedProducts = try? JSONDecoder().decode([Product].self, from: data) {
                return decodedProducts
            }
            
            return []
        }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return products.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
           let product = products[indexPath.item]
           
           cell.productLabel.text = product.isim
           cell.productImage.image = UIImage(named: product.gorsel)
           
           return cell
       }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8 
        let interItemSpacing: CGFloat = 4

        let totalPadding = padding * 2 + interItemSpacing * 2
        let availableWidth = collectionView.bounds.width - totalPadding
        let width = availableWidth / 3

        return CGSize(width: width - 6, height: (width - 6) + 30)
    }


    // Satır arası minimum boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }


}
