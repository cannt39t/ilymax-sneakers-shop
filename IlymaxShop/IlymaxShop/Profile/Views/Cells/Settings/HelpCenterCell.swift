//
//  HelpCenterCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//

import UIKit


class HelpCenterCell: UICollectionViewCell {
    
    public static let identifier = "HelpCenterCell"
    private let nameLabel: UILabel = .init()
    private var chevronRight: UIImageView = .init()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textColor = .label
        
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        chevronRight = UIImageView(image: image)
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, chevronRight])
        mainStack.alignment = .leading
        mainStack.spacing = 6
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronRight.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: chevronRight.centerYAnchor),
        ])
    }
    
    public func setName(_ text: String) {
        nameLabel.text = text
    }
}

