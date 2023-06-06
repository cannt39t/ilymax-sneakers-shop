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
        layer.cornerRadius = 10
        layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
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
        shoeImage.image = nil
        self.shoe = shoes
        nameLabel.text = shoes.name
        fromPriceLabel.text = "from \(shoes.lowestPrice)$"

        
        guard let imageUrlString = shoes.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            // Show error message to user if image URL is nil
            return
        }
        
        loadImage(with: imageUrl)
    }

    private func loadImage(with url: URL) {
        shoeImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shoeImage.image = nil
    }

}
