//
//  PromotionCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import UIKit

class PromotionCell: UICollectionViewCell {
    
    public static let indertifier = "PromotionCell"
    private var promotionImage: UIImageView = .init()
    private var promotion: IlymaxPromotion?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(promotionImage)
        promotionImage.contentMode = .scaleToFill
        promotionImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promotionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            promotionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            promotionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            promotionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    public func setPromotion(promotion: IlymaxPromotion) {
        self.promotion = promotion
        let imageURL = URL(string: promotion.imageUrl)!
        configure(with: imageURL)
    }
    
    private func configure(with url: URL) {
        promotionImage.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        promotionImage.image = nil
    }
    
}
