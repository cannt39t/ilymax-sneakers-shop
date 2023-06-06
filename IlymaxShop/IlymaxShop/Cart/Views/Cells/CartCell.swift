//
//  CartCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 21.03.2023.
//

import UIKit

class CartCell: UITableViewCell {
        
    public static let indertifier = "CartCell"
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imgImageView: UIImageView = .init()
    private var nameLabel: UILabel = .init()
    private var sizeLabel: UILabel = .init()
    private var priceLabel: UILabel = .init()
    private var productID: String = .init()

    func setProduct (product: IlymaxCartItem) {
        productID = product.id
        nameLabel.text = "\(product.company) \(product.name)"
        nameLabel.textColor = .label
        sizeLabel.text = "Size: \(product.data.size)"
        sizeLabel.textColor = .label
        priceLabel.text = "\(product.data.price) $"
        priceLabel.textColor = .label
        
        guard let imageUrl = URL(string: product.imageUrl) else {
            // Show error message to user if image URL is nil
            return
        }
        
        loadImage(with: imageUrl)
    }
    


    private func loadImage(with url: URL) {
        imgImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func setup() {
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .systemGroupedBackground
        
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

        NSLayoutConstraint.activate([
            imgImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imgImageView.heightAnchor.constraint(equalTo: imgImageView.widthAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: imgImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
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
