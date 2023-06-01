//
//  ProfileCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import UIKit

class ProfileCell: UICollectionViewCell {
    
    public static let identifier = "ProfileCell"
    private let titleLabel: UILabel = .init()
    private let informationLabel: UILabel = .init()
    private let forwardImage: UIImageView =  .init(image: UIImage(systemName: "chevron.forward")!.withTintColor(.label, renderingMode: .alwaysOriginal))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        backgroundColor = .secondarySystemGroupedBackground
        
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.textColor = .label
        
        informationLabel.font = informationLabel.font.withSize(15)
        informationLabel.textColor = .secondaryLabel
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, informationLabel])
        mainStack.alignment = .leading
        mainStack.spacing = 12
        mainStack.axis = .vertical
    
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        forwardImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        contentView.addSubview(forwardImage)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: forwardImage.leadingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            forwardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            forwardImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(with title: String, _ info: String) {
        titleLabel.text = title
        informationLabel.text = info
    }
    
}
