//
//  UserCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    public static let identifier = "UserCell"
    public var userImage: UIButton = .init()
    private let nameLabel: UILabel = .init()
    private let emailLabel: UILabel = .init()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        nameLabel.font = nameLabel.font.withSize(20)
        
        emailLabel.textColor = .gray
        
        userImage.layer.cornerRadius = 20
        userImage.clipsToBounds = true
        userImage.contentHorizontalAlignment = .fill
        userImage.contentVerticalAlignment = .fill
        
        let profileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        userImage.setImage(profileImage, for: .normal)
        userImage.imageView?.contentMode = .scaleAspectFill
    }
    
    private func setup() {
        setupDesign()
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.distribution = .fillEqually
        
        contentView.addSubview(userImage)
        contentView.addSubview(stack)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            stack.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    
    func setUser(user: IlymaxUser) {
        nameLabel.text = user.name
        emailLabel.text = user.emailAddress
        
        // load image from firebase
    }
    
    
    func setImage(_ image: UIImage) {
        userImage.setImage(image, for: .normal)
    }
}
