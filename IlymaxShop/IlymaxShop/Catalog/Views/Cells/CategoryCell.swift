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
//        contentView.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [categoryImage, nameLabel])
        stack.alignment = .leading
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryImage.widthAnchor.constraint(equalTo: categoryImage.heightAnchor)
        ])
    }
    
    public func setCategory(category: IlymaxCategory) {
        self.category = category
        nameLabel.text = category.name
        FirestoreManager.shared.getImageUrlFromStorageUrl(category.imageUrl) { [weak self] error, url in
            if let error {
                print(error)
                return
            }
            if let url {
                self?.configure(with: url)
            }
        }
    }
    
    private func configure(with url: URL) {
        categoryImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
    }
}
