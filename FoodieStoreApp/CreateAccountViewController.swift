//
//  CreateAccountViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 26.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

               print("FIREBASE APP: \(String(describing: FirebaseApp.app()))")
               print("FIREBASE AUTH: \(String(describing: Auth.auth()))")
               
               if Auth.auth().app == nil {
                   print("UYARI: Firebase Auth düzgün yapılandırılmamış!")
               }
               
               setupUI()

        
    }
    
    func setupUI() {
         let codeLabel = UILabel()
         codeLabel.text = " +90 | "
         codeLabel.font = UIFont.systemFont(ofSize: 18)
         codeLabel.textColor = .darkGray
         codeLabel.textAlignment = .center
         codeLabel.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
         
         phoneTextField.leftView = codeLabel
         phoneTextField.leftViewMode = .always
         phoneTextField.placeholder = "Numaranızı giriniz"
         phoneTextField.keyboardType = .phonePad
         
         nextButton.setTitleColor(.white, for: .normal)
     }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
                let surname = surnameTextField.text, !surname.isEmpty,
                let phone = phoneTextField.text, !phone.isEmpty else {
              showAlert(title: "Uyarı", message: "Lütfen tüm alanları doldurun.")
              return
          }
          
          var fullPhone = phone
          if fullPhone.hasPrefix("0") {
              fullPhone = String(fullPhone.dropFirst())
          }
          if !fullPhone.hasPrefix("+90") {
              fullPhone = "+90" + fullPhone
          }
          
          print("Doğrulanacak telefon: \(fullPhone)")
          
          guard FirebaseApp.app() != nil else {
              showAlert(title: "Firebase Hatası", message: "Firebase düzgün yapılandırılmamış.")
              return
          }
          
          guard Auth.auth().app != nil else {
              showAlert(title: "Firebase Auth Hatası", message: "Firebase Auth düzgün yapılandırılmamış.")
              return
          }
          
          #if targetEnvironment(simulator)
          verifyPhoneNumberForSimulator(fullPhone, name: name, surname: surname)
          #else
          verifyPhoneNumberForDevice(fullPhone, name: name, surname: surname)
          #endif
      }
      
      func verifyPhoneNumberForSimulator(_ phoneNumber: String, name: String, surname: String) {
          guard let app = FirebaseApp.app() else {
                 showAlert(title: "Firebase Hatası", message: "Firebase App bulunamadı.")
                 return
             }

             let auth = Auth.auth()
             print("Auth instance: \(auth)")
             print("Auth app: \(String(describing: auth.app))")


             guard let _ = auth.app else {
                 print("Auth.app nil olduğu için provider oluşturulamaz.")
                 self.showAlert(title: "Hata", message: "Firebase Auth app içeriği eksik.")
                 return
             }

          print("Firebase durumu kontrol edildi, PhoneAuth başlatılıyor...")
          
          DispatchQueue.global(qos: .userInitiated).async { [weak self] in
              let provider = PhoneAuthProvider.provider()

              DispatchQueue.main.async {
                  guard let self = self else { return }
                  print("PhoneAuthProvider başarıyla oluşturuldu")
                  
                  provider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                      DispatchQueue.main.async {
                          guard let self = self else { return }
                          
                          if let error = error {
                              print("Phone Auth Error: \(error.localizedDescription)")
                              print("Error Code: \((error as NSError).code)")
                              print("Error Domain: \((error as NSError).domain)")
                              
                              if error.localizedDescription.contains("simulator") ||
                                 error.localizedDescription.contains("test") ||
                                 (error as NSError).code == 17999 {
                                  self.showAlert(title: "Test Numarası Gerekli",
                                               message: "Simülatörde test etmek için Firebase Console'da bu numarayı test numarası olarak eklemeniz gerekiyor.\n\nNumara: \(phoneNumber)\n\nFirebase Console > Authentication > Sign-in method > Phone > Phone numbers for testing kısmına bu numarayı ve bir test kodu (örn: 123456) ekleyin.")
                              } else {
                                  self.showAlert(title: "Hata",
                                               message: "Doğrulama kodu gönderilemedi.\n\nHata: \(error.localizedDescription)")
                              }
                              return
                          }
                          
                          guard let verificationID = verificationID else {
                              self.showAlert(title: "Hata", message: "Doğrulama ID'si alınamadı")
                              return
                          }
                          
                          print("Verification ID alındı: \(verificationID)")
                          
                          self.saveToFirestore(phoneNumber, name: name, surname: surname)
                          
                          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                          UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                          UserDefaults.standard.set(true, forKey: "isTestMode")
                          
                          self.performSegue(withIdentifier: "toPasswordVC", sender: nil)
                      }
                  }
              }
          }
      }
      
      func verifyPhoneNumberForDevice(_ phoneNumber: String, name: String, surname: String) {
          // Güvenlik kontrolleri
          guard Auth.auth().app != nil else {
              showAlert(title: "Firebase Auth Hatası", message: "Firebase Auth düzgün yapılandırılmamış.")
              return
          }
          
          DispatchQueue.global(qos: .userInitiated).async { [weak self] in
              let provider = PhoneAuthProvider.provider(auth: Auth.auth())
              
              DispatchQueue.main.async {
                  guard let self = self else { return }
                  
                  provider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                      DispatchQueue.main.async {
                          guard let self = self else { return }
                          
                          if let error = error {
                              print("Phone Auth Error: \(error.localizedDescription)")
                              self.showAlert(title: "Hata", message: "Doğrulama kodu gönderilemedi: \(error.localizedDescription)")
                              return
                          }
                          
                          guard let verificationID = verificationID else {
                              self.showAlert(title: "Hata", message: "Doğrulama ID'si alınamadı")
                              return
                          }
                          
                          self.saveToFirestore(phoneNumber, name: name, surname: surname)
                          
                          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                          UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                          UserDefaults.standard.set(false, forKey: "isTestMode")
                          
                          self.performSegue(withIdentifier: "toPasswordVC", sender: nil)
                      }
                  }
              }
          }
      }
      
      func saveToFirestore(_ phoneNumber: String, name: String, surname: String) {
          let db = Firestore.firestore()
          db.collection("pendingUsers").document(phoneNumber).setData([
              "name": name,
              "surname": surname,
              "phone": phoneNumber,
              "timestamp": FieldValue.serverTimestamp()
          ]) { err in
              if let err = err {
                  print("Firestore hata: \(err.localizedDescription)")
              } else {
                  print("Veri geçici olarak kaydedildi.")
              }
          }
      }
     
   
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPasswordVC" {
            if let destinationVC = segue.destination as? PasswordViewController {
                destinationVC.textForLabel = "SMS Doğrulama Kodu"
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
