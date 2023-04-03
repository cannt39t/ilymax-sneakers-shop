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
    public var shoesIds: [String] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        contentView.addSubview(promotionImage)
        promotionImage.contentMode = .scaleAspectFill
        promotionImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promotionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            promotionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            promotionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            promotionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    public func setPromotion(promotion: Promotion) {
        
    }
    
}