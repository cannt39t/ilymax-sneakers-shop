//
//  ModalAddingViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ModalAddingViewController: UIViewController {
    var product: Shoes!
    var presenter: ProductListPresenter!
    
    private var picker: UIPickerView = .init()
    private var imageView: UIImageView = .init()
    private var addButton: UIButton = .init(type: .system)
    private var selectedRow: Int?
    private var hud = JGProgressHUD()
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = product!.data.map { $0.size }
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)

        view.addSubview(imageView)
        
        picker.dataSource = self
        picker.delegate = self
        view.addSubview(picker)

        addButton.setTitle("Add to Cart", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        addButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        addButton.tintColor = .label
        view.addSubview(addButton)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            picker.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.backgroundColor = .systemGroupedBackground
        
        guard let imageUrlString = product.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            // Show error message to user if image URL is nil
            return
        }
        
        loadImage(with: imageUrl)
    }
    
    func showSucces() {
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.square = true
        hud.textLabel.text = "Log in to add"
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 1.0)
    }

    private func loadImage(with url: URL) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
            } 
        }
    }

    
    @objc private func addToCartTapped() {
        guard (FirebaseAuth.Auth.auth().currentUser?.uid) != nil else {
            showSucces()
            return
        }
        let ilymaxCartItem = IlymaxCartItem(id: product.id!, name: product.name, description: product.description, color: product.color, gender: product.gender, condition: product.condition, imageUrl: product.imageUrl!, data: ShoesDetail(size: product.data[selectedRow ?? 0].size, price: product.data[selectedRow ?? 0].price, quantity: 1), ownerId: product.ownerId, company: product.company, category: product.category)
        presenter?.addToCart(ilymaxCartItem: ilymaxCartItem)
        dismiss(animated: true)
    }
    
}

extension ModalAddingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
}

extension ModalAddingViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(data[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

