//
//  BasketViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import UIKit

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alisveriseBaslaButton: UIButton!
    @IBOutlet weak var emptyBasketView: UIView!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alisveriseBaslaButton.setTitleColor(.white, for: .normal)
        
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            updateUI()
        }
    
    func updateUI() {
            let hasItems = !BasketManager.shared.items.isEmpty
            
            emptyBasketView.isHidden = hasItems
            basketTableView.isHidden = !hasItems
            
            if hasItems {
                let total = BasketManager.shared.calculateTotalPrice()
            }
            
            basketTableView.reloadData()
        }
    
    func setupUI() {
            alisveriseBaslaButton.setTitleColor(.white, for: .normal)
            alisveriseBaslaButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            alisveriseBaslaButton.layer.cornerRadius = 8
        }
        
        func setupTableView() {
            basketTableView.delegate = self
            basketTableView.dataSource = self

        }
    

    @IBAction func alisveriseBaslaClicked(_ sender: Any) {
        if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0 // Ana sayfa sekmesine git
                }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return BasketManager.shared.items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as! BasketTableViewCell
            
            let basketItem = BasketManager.shared.items[indexPath.row]
            cell.configure(with: basketItem)
            
            return cell
        }
        
        // MARK: - TableView Delegate
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let productName = BasketManager.shared.items[indexPath.row].product.isim
                BasketManager.shared.removeFromBasket(productName: productName)
                
                updateUI()
            }
        }
}
