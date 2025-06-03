//
//  PasswordViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 26.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!
    
    var textForLabel: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        [textField1, textField2, textField3, textField4, textField5, textField6].forEach {
            $0?.delegate = self
            $0?.keyboardType = .numberPad
            $0?.textAlignment = .center
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            $0?.layer.cornerRadius = 5
        }
        
        textLabel.text = textForLabel
        
       
        textField1.becomeFirstResponder()
        let isTestMode = UserDefaults.standard.bool(forKey: "isTestMode")
        if isTestMode {
            print("Simülatör test modunda - Firebase test kodu giriniz")
            textLabel.text = "SMS Kodunu Giriniz"
        }
        
        fetchUserName()
    }
    
    func fetchUserName() {
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") else {
                print("Telefon numarası bulunamadı.")
                return
            }
            
            print("Kullanıcı numarası: \(phoneNumber)")
            
            let db = Firestore.firestore()
            db.collection("pendingUsers").document(phoneNumber).getDocument { (document, error) in
                if let error = error {
                    print("Firestore hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("pendingUsers içinde bu numara için belge bulunamadı.")
                    return
                }
                
                let name = document.get("name") as? String ?? "Kullanıcı"
                
                DispatchQueue.main.async {
                    self.nameLabel.text = "Merhaba \(name)"
                }
            }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        if string.isEmpty {
            textField.text = ""
            moveToPreviousTextField(from: textField)
            return false
        }
        
        guard let text = textField.text else { return true }
        
        if (text + string).count > 1 {
            return false
        }
        
        textField.text = string
        moveToNextTextField(from: textField)
        
        return false
    }
        
    func moveToNextTextField(from textField: UITextField) {
        switch textField {
        case textField1:
            textField2.becomeFirstResponder()
        case textField2:
            textField3.becomeFirstResponder()
        case textField3:
            textField4.becomeFirstResponder()
        case textField4:
            textField5.becomeFirstResponder()
        case textField5:
            textField6.becomeFirstResponder()
        case textField6:
            textField6.resignFirstResponder()
            // Otomatik doğrulama yap
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.verifyCode()
            }
        default:
            break
        }
    }
    
    func moveToPreviousTextField(from textField: UITextField) {
        switch textField {
        case textField6:
            textField5.becomeFirstResponder()
        case textField5:
            textField4.becomeFirstResponder()
        case textField4:
            textField3.becomeFirstResponder()
        case textField3:
            textField2.becomeFirstResponder()
        case textField2:
            textField1.becomeFirstResponder()
        case textField1:
            textField1.becomeFirstResponder()
        default:
            break
        }
    }
    
    func verifyCode() {
        // Kodları birleştir
        let c1 = textField1.text ?? ""
        let c2 = textField2.text ?? ""
        let c3 = textField3.text ?? ""
        let c4 = textField4.text ?? ""
        let c5 = textField5.text ?? ""
        let c6 = textField6.text ?? ""
        
        let code = c1 + c2 + c3 + c4 + c5 + c6
        
        guard code.count == 6 else {
            showAlert(message: "Lütfen 6 haneli doğrulama kodunu eksiksiz girin.")
            return
        }
        
        handleFirebaseVerification(code: code)
    }
    
    func handleFirebaseVerification(code: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            showAlert(message: "Doğrulama bilgisi bulunamadı. Lütfen tekrar deneyin.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Doğrulama hatası: \(error.localizedDescription)")
                    self.showAlert(message: "Doğrulama başarısız: \(error.localizedDescription)")
                    self.clearTextFields()
                    return
                }
                
                print("Firebase Authentication başarılı!")
                
                self.moveUserDataToMainCollection()
            }
        }
    }
    
    func moveUserDataToMainCollection() {
        guard let user = Auth.auth().currentUser,
              let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") else {
            showAlert(message: "Kullanıcı bilgisi alınamadı.")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("pendingUsers").document(phoneNumber).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Pending user bilgisi alınamadı: \(error.localizedDescription)")
                    self.goToHomePage()
                    return
                }
                
                guard let document = document, document.exists,
                      let data = document.data() else {
                    print("Pending user document bulunamadı")
                    self.goToHomePage()
                    return
                }
                
                let isTestMode = UserDefaults.standard.bool(forKey: "isTestMode")
                
                db.collection("users").document(user.uid).setData([
                    "name": data["name"] ?? "",
                    "surname": data["surname"] ?? "",
                    "phone": phoneNumber,
                    "userID": user.uid,
                    "isTestUser": isTestMode,
                    "createdAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        print("Kullanıcı ana koleksiyona kaydedilemedi: \(error.localizedDescription)")
                    } else {
                        print("Kullanıcı başarıyla kaydedildi")
                        db.collection("pendingUsers").document(phoneNumber).delete()
                    }
                    
                    self.goToHomePage()
                }
            }
        }
    }
    
    func goToHomePage() {
        UserDefaults.standard.removeObject(forKey: "authVerificationID")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "isTestMode")
        
        performSegue(withIdentifier: "toHomeVC", sender: nil)
    }
    
    func clearTextFields() {
        [textField1, textField2, textField3, textField4, textField5, textField6].forEach {
            $0?.text = ""
        }
        textField1.becomeFirstResponder()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            self.clearTextFields()
        })
        present(alert, animated: true)
    }
}
