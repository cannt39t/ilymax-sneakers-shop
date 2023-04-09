//
//  PopularCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import UIKit
import SDWebImage

class PopularCell: UICollectionViewCell {
    
    public static let indertifier = "PopularCell"
    private var shoeImage: UIImageView = .init()
    private var nameLabel: UILabel = .init()
    private var fromPriceLabel: UILabel = .init()
    public var shoe: Shoes?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        contentView.addSubview(shoeImage)
        shoeImage.contentMode = .scaleAspectFit
        shoeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shoeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shoeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shoeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shoeImage.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    public func configure(with shoes: Shoes) {
        shoeImage.image = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        self.shoe = shoes
        nameLabel.text = shoes.name
        fromPriceLabel.text = "from \(shoes.lowestPrice)$"
        
        guard let imageUrl = shoes.imageUrl else {
            // Show error message to user if image URL is nil
            return
        }
        
        FirestoreManager.shared.getImageUrlFromStorageUrl(imageUrl) { [weak self] error, url in
            guard let self = self else { return } // Make sure self is not nil
            
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let url = url else {
                // Show error message to user if URL is nil
                return
            }
            
            self.loadImage(with: url)
        }
    }

    private func loadImage(with url: URL) {
        shoeImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
            } else {
//                if cacheType == .memory || cacheType == .disk {
//                    print("Image loaded from cache")
//                } else {
//                    print("Image loaded from network")
//                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shoeImage.image = nil
    }

}
