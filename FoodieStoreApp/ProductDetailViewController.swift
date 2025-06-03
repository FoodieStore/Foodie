//
//  ProductDetailViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 29.04.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    
    @IBOutlet weak var stepperView: UIStepper!
    @IBOutlet weak var quantitlyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            nameLabel.text = product.turkceisim
            priceLabel.text = product.fiyat
            descriptionLabel.text = product.aciklama
            imageView.image = UIImage(named: product.gorsel)
            
            imageView.layer.cornerRadius = 12
            buyButton.setTitleColor(.white, for: .normal)
            
            setupUI()
            updateQuantityLabel()
            
        }
        
    }
        
        func setupUI() {
            imageView.layer.cornerRadius = 12
            buyButton.setTitleColor(.white, for: .normal)
            buyButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            buyButton.layer.cornerRadius = 8
            
            stepperView.minimumValue = 1
            stepperView.maximumValue = 20
            stepperView.value = Double(quantity)
        }
        
        
    func updateQuantityLabel() {
        quantitlyLabel.text = "\(quantity) adet"
        
        if let product = product {
            let fiyatStr = product.fiyat.replacingOccurrences(of: "₺", with: "").trimmingCharacters(in: .whitespaces)
            if let birimFiyat = Double(fiyatStr) {
                let toplamFiyat = birimFiyat * Double(quantity)
                priceLabel.text = String(format: "%.2f ₺", toplamFiyat)
            }
        }
    }
        
        
        @IBAction func buyButtonClicked(_ sender: Any) {
            if let product = product {
                        BasketManager.shared.addToBasket(product: product, quantity: quantity)
                        
                        let alertController = UIAlertController(
                            title: "Ürün Sepete Eklendi",
                            message: "\(quantity) adet \(product.turkceisim) sepete eklendi.",
                            preferredStyle: .alert
                        )
                        
                        alertController.addAction(UIAlertAction(title: "Alışverişe Devam Et", style: .default))
                        alertController.addAction(UIAlertAction(title: "Sepete Git", style: .default) { _ in
                            if let tabBarController = self.tabBarController {
                                tabBarController.selectedIndex = 1 
                            }
                        })
                        
                        present(alertController, animated: true)
                    }
        }
    
        @IBAction func stepperValueChanged(_ sender: Any) {
            if let stepper = sender as? UIStepper {
                    quantity = Int(stepper.value)
                    updateQuantityLabel()
                }
        }
    }

