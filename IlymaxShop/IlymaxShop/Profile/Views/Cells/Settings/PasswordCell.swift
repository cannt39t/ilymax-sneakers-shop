//
//  PasswordCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//


import UIKit


class PasswordCell: UICollectionViewCell {
    
    public static let identifier = "PasswordCell"
    private let passwordLabel: UILabel = .init()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        passwordLabel.font = passwordLabel.font.withSize(16)
        passwordLabel.textColor = .label
        passwordLabel.text = "********"
        passwordLabel.addCharacterSpacing(kernValue: 4)
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [passwordLabel])
        mainStack.alignment = .leading
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
}

