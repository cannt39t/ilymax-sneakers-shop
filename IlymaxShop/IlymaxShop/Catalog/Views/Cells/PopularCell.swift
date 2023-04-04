//
//  PopularCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import UIKit

class PopularCell: UICollectionViewCell {
    
    public static let indertifier = "PopularCell"
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
        
    }
}
