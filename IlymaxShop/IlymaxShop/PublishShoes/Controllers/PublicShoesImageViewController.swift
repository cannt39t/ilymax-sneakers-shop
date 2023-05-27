//
//  PublicShoesImageViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import UIKit

class PublicShoesImageViewController: UIViewController {
    var presenter: PublicShoesPresenter!
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let genderLabel = UILabel()
    private let colorLabel = UILabel()
    private let categoryLabel = UILabel()
    private let conditionLabel = UILabel()
    private let dataLabel = UILabel()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(presenter.product.color)
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Adding"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.up")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(uploadButtonTapped))
        
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(systemName: "shoeprints.fill")
        imageView.tintColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genderLabel.font = UIFont.systemFont(ofSize: 16)
        genderLabel.textColor = .darkGray
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorLabel.font = UIFont.systemFont(ofSize: 16)
        colorLabel.textColor = .darkGray
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        categoryLabel.textColor = .darkGray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        conditionLabel.textColor = .darkGray
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dataLabel.font = UIFont.systemFont(ofSize: 16)
        dataLabel.textColor = .darkGray
        dataLabel.numberOfLines = 0
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        

        
        nameLabel.text = "\(presenter.product.company) \(presenter.product.name)"
        descriptionLabel.text = "\(presenter.product.description)"
        colorLabel.text = "\(presenter.product.color)"
        genderLabel.text = "\(presenter.product.gender)"
        categoryLabel.text = "\(presenter.product.category)"
        conditionLabel.text = "\(presenter.product.condition)"
        var dataString = ""

        for shoeDetail in presenter.product.data {
            dataString += "Size: \(shoeDetail.size)\n"
            dataString += "Price: \(shoeDetail.price)$\n"
            dataString += "Quantity: \(shoeDetail.quantity)\n\n"
        }
        dataLabel.text = dataString
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(colorLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(conditionLabel)
        stackView.addArrangedSubview(dataLabel)
       
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func uploadButtonTapped() {
        if imageView.image != UIImage(systemName: "shoeprints.fill") {
            presenter.addToDB(with: presenter.product, image: imageView.image!)
            presenter.restart()
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "The upload is not available", message: "Please add image", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func tapOnImage(_ sender: UITapGestureRecognizer) {
        presentPhotoInputActionsheet()
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Change profile image", message: "What would you like to attach a photo from?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}

extension PublicShoesImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            if let image = pickedImage.fixedOrientation() {
                print("Fixed image orientation")
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
            } else {
                imageView.image = pickedImage
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
            }
        }
        dismiss(animated: true)
    }
}
