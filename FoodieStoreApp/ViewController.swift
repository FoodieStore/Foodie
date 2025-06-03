//
//  ViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 2.04.2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.setTitleColor(.white, for: .normal) 
        
    }

    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccountVC", sender: nil)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    
}

