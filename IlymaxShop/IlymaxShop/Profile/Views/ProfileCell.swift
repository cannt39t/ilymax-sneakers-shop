//
//  ProfileCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import UIKit

class ProfileCell: UICollectionViewCell {
    
    public static let indertifier = "ProfileCell"
    private let titleLabel: UILabel = .init()
    private let informationLabel: UILabel = .init()
    private let forwardImage: UIImageView =  .init(image: UIImage(systemName: "chevron.forward")!)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        backgroundColor = .white
        
        titleLabel.font = titleLabel.font.withSize(30)
        titleLabel.textColor = .black
        
        informationLabel.font = informationLabel.font.withSize(15)
        informationLabel.textColor = .gray
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, informationLabel])
        mainStack.alignment = .leading
        mainStack.spacing = 12
        mainStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [mainStack, forwardImage])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
        ])
    }
    
}
