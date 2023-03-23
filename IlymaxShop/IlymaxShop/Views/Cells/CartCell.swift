//
//  CartCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import UIKit

class CartCell: UICollectionViewCell {
        
    public static let indertifier = "CartCell"
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    private var imgImageView: UIImageView = .init()
    private var nameLabel: UILabel = .init()
    private var sizeLabel: UILabel = .init()
    private var priceLabel: UILabel = .init()
    private var deleteButton: UIButton = .init()
    private var productID: Int = .init()
    
    func setProduct (product: Product) {
        productID = product.id
        nameLabel.text = "\(product.name)"
        nameLabel.textColor = .black
        sizeLabel.text = "Size: \(product.size) US"
        sizeLabel.textColor = .black
        priceLabel.text = "$\(product.price)"
        priceLabel.textColor = .black
       // imgImageView.image = UIImage(named: "Welcome")
        loadImage(url: URL(string: "\(product.description)")!)
        
        deleteButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        
        deleteButton.tintColor = .black
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Узнать как удалять
    @objc private func deleteButtonTapped() {
        //productID
    }
    
    private var dataTask: URLSessionDataTask?

    private func loadImage(url: URL) {
        imgImageView.image = nil
        dataTask?.cancel()
        let urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData
        )
        dataTask = URLSession.shared
            .dataTask(with: urlRequest) { [imgImageView] data, _, _ in
                guard let data else {
                    print("could not load image")
                    return
                }

                let image = UIImage(data: data)
                DispatchQueue.main.async { [imgImageView] in
                    guard let image else { return }
                    imgImageView.image = image
                }
            }
        dataTask?.resume()
    }
    
    private func setup() {
        imgImageView.contentMode = .scaleAspectFit
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(imgImageView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
            
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(sizeLabel)
        stackView.addArrangedSubview(priceLabel)
        
        imgImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

        imgImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
        imgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -5),
        imgImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        imgImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -10),
        
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        stackView.leadingAnchor.constraint(equalTo: imgImageView.trailingAnchor, constant: 10),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        
        deleteButton.centerXAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
    }
    
}

extension UIImage {
    func resizeImage(maxSize: CGFloat) -> UIImage? {
        let scale = maxSize / max(size.width, size.height)
        let newWidth = size.width * scale
        let newHeight = size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
