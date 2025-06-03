//
//  CameraViewController.swift
//  FoodieStoreApp
//
//  Created by selinay ceylan on 28.04.2025.
//

import UIKit
import Vision
import CoreML

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            showImageSourceSelection()
        }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func showImageSourceSelection() {
            let alert = UIAlertController(title: "Ürün Tanıma", message: "Nasıl devam etmek istersiniz?", preferredStyle: .actionSheet)

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "Kamera", style: .default) { _ in
                    self.openImagePicker(sourceType: .camera)
                })
            }

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alert.addAction(UIAlertAction(title: "Galeriden Seç", style: .default) { _ in
                    self.openImagePicker(sourceType: .photoLibrary)
                })
            }

            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            present(alert, animated: true)
        }

    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
            picker.allowsEditing = false
            present(picker, animated: true)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true) {
                if let image = info[.originalImage] as? UIImage {
                    self.selectedImage = image
                    self.predictImageContent(image: image)
                }
            }
        }
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetail",
           let destinationVC = segue.destination as? ProductDetailViewController,
           let product = sender as? Product {
            destinationVC.product = product
        }
    }

    
    
    func predictImageContent(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("CIImage'a çevrilemedi.")
            return
        }

        guard let model = try? VNCoreMLModel(for: Foodie_1().model) else {
            print("Model yüklenemedi.")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("Sonuçlar alınamadı.")
                return
            }

            if let firstObject = results.first,
               let bestLabel = firstObject.labels.first {
                
                let urunAdi = bestLabel.identifier
                print("Tanımlanan ürün: \(urunAdi) - Güven: \(Int(bestLabel.confidence * 100))%")

                DispatchQueue.main.async {
                    if let bulunanUrun = self.findProduct(byName: urunAdi) {
                        self.performSegue(withIdentifier: "ShowProductDetail", sender: bulunanUrun)
                    } else {
                        print("Ürün JSON dosyasında bulunamadı: \(urunAdi)")
                    }
                }
            } else {
                print("Ürün tespit edilemedi.")
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
    
    func loadAllProducts() -> [Product] {
        let filenames = ["atistirmaliklar", "meyveler", "sebzeler"]
        var allProducts: [Product] = []

        for filename in filenames {
            if let url = Bundle.main.url(forResource: filename, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let products = try? JSONDecoder().decode([Product].self, from: data) {
                allProducts.append(contentsOf: products)
            }
        }

        return allProducts
    }
    
    func findProduct(byName name: String) -> Product? {
        let allProducts = loadAllProducts()
        return allProducts.first { $0.isim == name }
    }


        
}
