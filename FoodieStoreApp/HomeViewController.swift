

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    struct Category {
        let name: String
        let imageName: String
    }

    let categories: [Category] = [
        Category(name: "Meyve", imageName: "meyve"),
        Category(name: "Sebze", imageName: "sebze"),
        Category(name: "Atıştırmalık", imageName: "paketligida"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
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
        
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.minimumInteritemSpacing = 8
                flowLayout.minimumLineSpacing = 8
                flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        
        imageView2.layer.cornerRadius = 12
        textLabel2.layer.cornerRadius = 12
        textLabel2.layer.masksToBounds = true
        textLabel2.backgroundColor = UIColor(red: 111/255.0, green: 145/255.0, blue: 59/255.0, alpha: 1.0)


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductVC" {
            if let indexPath = sender as? IndexPath,
               let destinationVC = segue.destination as? ProductViewController {
                let selectedCategory = categories[indexPath.item]
                destinationVC.selectedCategoryName = selectedCategory.name
            }
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        
        cell.imageView.image = UIImage(named: category.imageName)
        cell.titleLabel.text = category.name
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let interItemSpacing: CGFloat = 8
        
        let totalSpacing = padding * 2 + interItemSpacing * 2
        let availableWidth = collectionView.bounds.width - totalSpacing
        let width = availableWidth / 3
        
        return CGSize(width: width, height: width + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProductVC", sender: indexPath)
    }

}

