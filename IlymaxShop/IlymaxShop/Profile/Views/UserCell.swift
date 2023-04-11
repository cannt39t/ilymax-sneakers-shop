//
//  UserCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    public static let indertifier = "UserCell"
    private var userImage: UIButton = .init()
    private let nameLabel: UILabel = .init()
    private let emailLabel: UILabel = .init()
    private var promotion: IlymaxUser?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setupDesign() {
        emailLabel.textColor = .gray
        
        userImage.contentMode = .scaleAspectFit
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
    }
    
    private func setup() {
        setupDesign()
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        
        contentView.addSubview(userImage)
        contentView.addSubview(stack)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            stack.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func setUser(user: IlymaxUser) {
        nameLabel.text = user.name
        emailLabel.text = user.emailAddress
        
        // load image from firebase
    }
    
}
