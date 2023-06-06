//
//  CategoryCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import Foundation


import UIKit

class CategoryCell: UICollectionViewCell {
    
    public static let indertifier = "CategoryCell"
    private var categoryImage: UIImageView = .init()
    private let forwardImage: UIImageView =  .init(image: UIImage(systemName: "chevron.forward")!.withTintColor(.label, renderingMode: .alwaysOriginal))
    private var nameLabel: UILabel = .init()
    
    public var category: IlymaxCategory?
    
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
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
        
        
        let stack = UIStackView(arrangedSubviews: [categoryImage, nameLabel])
        stack.alignment = .leading
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        
        contentView.addSubview(stack)
        forwardImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(forwardImage)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: forwardImage.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryImage.widthAnchor.constraint(equalToConstant: 50),
            categoryImage.heightAnchor.constraint(equalToConstant: 50),
            
            forwardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            forwardImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func setCategory(category: IlymaxCategory) {
        self.category = category
        nameLabel.text = category.name
        let imageURL = URL(string: category.imageUrl)!
        configure(with: imageURL)
    }
    
    private func configure(with url: URL) {
        categoryImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { [weak self] (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else if let image = image {
                let tintedImage = image.withTintColor(.label, renderingMode: .alwaysOriginal)
                self?.categoryImage.image = tintedImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
    }
}
