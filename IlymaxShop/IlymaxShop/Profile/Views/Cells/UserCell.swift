//
//  UserCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.04.2023.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    public static let identifier = "UserCell"
    
    public let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }
    
    private func setupDesign() {
        nameLabel.font = nameLabel.font.withSize(24)
        nameLabel.textColor = .label
        
        emailLabel.textColor = .secondaryLabel
    }
    
    private func setup() {
        setupDesign()
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        stack.distribution = .fillEqually
        
        contentView.addSubview(userImageView)
        contentView.addSubview(stack)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            stack.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }

    
    func setUser(user: IlymaxUser) {
        nameLabel.text = user.name
        emailLabel.text = user.emailAddress
        
        if let imageURLString = user.profilePictureUrl, let imageURL = URL(string: imageURLString) {
            configure(with: imageURL)
        }
    }
    
    private func configure(with url: URL) {
        DispatchQueue.main.async { [unowned self] in
            userImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal), options: [.highPriority]) { [unowned self] (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
                userImageView.layer.cornerRadius = userImageView.frame.width / 2
                userImageView.layer.masksToBounds = true
            }
        }
    }
    
    func setImageProfile(_ image: UIImage) {
        userImageView.image = image
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }
}
