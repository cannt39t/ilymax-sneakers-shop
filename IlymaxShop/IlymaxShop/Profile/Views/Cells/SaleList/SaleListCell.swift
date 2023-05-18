//
//  SaleListCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.05.2023.
//

import UIKit
import SDWebImage


class SaleListCell: UICollectionViewCell {
    
    public static let identifier = "SaleListCell"
    
    private let shoesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = UIImage(systemName: "photo")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let desryptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
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
        
        let nameAndPriceStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        nameAndPriceStack.axis = .vertical
        nameAndPriceStack.alignment = .leading
        nameAndPriceStack.distribution = .fillEqually
        nameAndPriceStack.spacing = 18
        
        let topStack = UIStackView(arrangedSubviews: [shoesImageView, nameAndPriceStack])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.spacing = 12
        
        let bottomStack = UIStackView(arrangedSubviews: [dateLabel, desryptionLabel])
        bottomStack.axis = .vertical
        bottomStack.alignment = .center
        bottomStack.spacing = 12
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topStack)
        contentView.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            topStack.heightAnchor.constraint(equalToConstant: 100),
            
            shoesImageView.widthAnchor.constraint(equalToConstant: 100),
            shoesImageView.heightAnchor.constraint(equalToConstant: 100),
            
            topStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            topStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            topStack.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: -12),
            
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    public func configure(with shoe: Shoes) {
        nameLabel.text = shoe.name
        priceLabel.text = "from $ \(shoe.lowestPrice)"
        dateLabel.text = "20/03/2020"
        desryptionLabel.text = shoe.description
        
        guard let imageUrlString = shoe.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            // Show error message to user if image URL is nil
            return
        }
        
        loadImage(with: imageUrl)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func loadImage(with url: URL) {
        shoesImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
