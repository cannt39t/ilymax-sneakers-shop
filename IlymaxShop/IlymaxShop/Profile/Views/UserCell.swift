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
        nameLabel.font = nameLabel.font.withSize(24)
        
        emailLabel.textColor = .gray
        
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
        stack.spacing = 2
        stack.alignment = .leading
        stack.distribution = .fillEqually
        
        contentView.addSubview(userImage)
        contentView.addSubview(stack)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
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
        
        if let url = user.profilePictureUrl {
            FirestoreManager.shared.getImageUrlFromStorageUrl(url) { [weak self] error, imageUrl in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if let imageUrl {
                    self?.configure(with: imageUrl)
                }
            }
        }
    }
    
    private func configure(with url: URL) {
        userImage.sd_setImage(with: url, for: .normal, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
        userImage.imageView!.layer.cornerRadius = userImage.imageView!.frame.size.height / 2
    }
    
    
    func setImageProfile(_ image: UIImage) {
        userImage.setImage(image, for: .normal)
        userImage.imageView!.layer.cornerRadius = userImage.imageView!.frame.size.height / 2
    }
    
}
