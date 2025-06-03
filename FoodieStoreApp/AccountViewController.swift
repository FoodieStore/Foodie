//
//  AccountViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let menuItems = ["Siparişlerim", "Değerlendirmelerim", "Ayarlar", "Hakkında", "Çıkış"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
 
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        
        switch selectedItem {
        case "Siparişlerim":
            // segue veya navigation işlemi
            print("Siparişlerim seçildi")
        case "Değerlendirmelerim":
            print("Değerlendirmelerim seçildi")
        case "Ayarlar":
            print("Ayarlar seçildi")
        case "Hakkında":
            print("Hakkında seçildi")
        case "Çıkış":
            do {
                try Auth.auth().signOut()
                print("Firebase çıkış başarılı")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                    
                    // SceneDelegate üzerinden rootViewController olarak ayarla
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.window?.rootViewController = loginVC
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }
                
            } catch let error {
                print("Çıkış hatası: \(error.localizedDescription)")
            }

        default:
            break
        }
    }
}
