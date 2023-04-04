//
//  PopularCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import UIKit

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
    
    public func setCategory(shoes: Shoes) {
        self.shoe = shoes
        nameLabel.text = shoes.name
        fromPriceLabel.text = "from \(shoes.lowestPrice)$"
        FirestoreManager.shared.getImageShoes(shoes.imageUrl!) { [weak self] error, image in
            self?.shoeImage.image = image
        }
    }
}
