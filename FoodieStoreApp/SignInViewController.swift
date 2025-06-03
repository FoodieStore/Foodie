//
//  SignInViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 26.04.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextFiled: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let codeLabel = UILabel()
            codeLabel.text = " +90 | "
            codeLabel.font = UIFont.systemFont(ofSize: 18)
            codeLabel.textColor = .darkGray
            codeLabel.textAlignment = .center
            codeLabel.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
        phoneNumberTextFiled.leftView = codeLabel
        phoneNumberTextFiled.leftViewMode = .always
        phoneNumberTextFiled.placeholder = "Numaranızı giriniz"
        phoneNumberTextFiled.keyboardType = .phonePad
        
        nextButton.setTitleColor(.white, for: .normal)

    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextFiled.text, !phoneNumber.isEmpty else {
               
                return
            }

            let fullNumber = "+90" + phoneNumber.trimmingCharacters(in: .whitespaces)
            UserDefaults.standard.set(fullNumber, forKey: "phoneNumber") 

            PhoneAuthProvider.provider().verifyPhoneNumber(fullNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("SMS gönderilemedi: \(error.localizedDescription)")
                    return
                }

                if let verificationID = verificationID {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print("Verification ID kaydedildi: \(verificationID)")

                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toPwdVC", sender: nil)
                    }
                }
            }
        }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPwdVC" {
            if let destinationVC = segue.destination as? PasswordViewController {
                destinationVC.textForLabel = "Şifrenizi Girin"
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    

}
