//
//  OrderItemCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.06.2023.
//

import UIKit
import SDWebImage


class OrderItemCell: UICollectionViewCell {
    
    public static let identifier = "OrderItemCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let descryptionView: UITextView = {
        let descryptionView = UITextView()
        descryptionView.textColor = .secondaryLabel
        descryptionView.isEditable = false
        descryptionView.isSelectable = true
        descryptionView.isScrollEnabled = false
        descryptionView.textContainerInset = .zero
        descryptionView.textContainer.lineFragmentPadding = 0
        descryptionView.backgroundColor = .clear
        return descryptionView
    }()
    
    private let itemImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    func setupDesign() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
    }
    
    func setup() {
        setupDesign()
        
        let rightStack = UIStackView(arrangedSubviews: [nameLabel, descryptionView])
        rightStack.axis = .vertical
        rightStack.alignment = .leading
        rightStack.spacing = 6
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(rightStack)
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
            
            rightStack.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 12),
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
    
    public func configure(with item: IlymaxCartItem) {
        guard let imageUrl = URL(string: item.imageUrl) else {
            // Show error message to user if image URL is nil
            return
        }
        loadImage(with: imageUrl)
        nameLabel.text = "\(item.company) \(item.name)"
        descryptionView.text = item.description
    }
    
    private func loadImage(with url: URL) {
        itemImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
