//
//  CustomHeaderView.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 17.05.2023.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
    }
    
    private func setupDesign() {
        nameLabel.font = nameLabel.font.withSize(24)
        nameLabel.textColor = .label
        
        emailLabel.textColor = .secondaryLabel
        
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
        stack.spacing = 3
        stack.alignment = .leading
        stack.distribution = .fillEqually
        
        addSubview(userImage)
        addSubview(stack)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            userImage.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            stack.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    
    func setUser(user: IlymaxUser) {
        nameLabel.text = user.name
        emailLabel.text = user.emailAddress
        
        if let imageURLString = user.profilePictureUrl, let imageURL = URL(string: imageURLString) {
            configure(with: imageURL)
        }
    }
    
    private func configure(with url: URL) {
        userImage.sd_setImage(with: url, for: .normal, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { [weak self] (image, error, cacheType, url) in
            guard let strongSelf = self else {
                fatalError()
            }
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
            
            strongSelf.userImage.layer.cornerRadius = strongSelf.userImage.frame.width / 2
            strongSelf.userImage.clipsToBounds = true
        }
    }
    
    func setImageProfile(_ image: UIImage) {
        userImage.setImage(image, for: .normal)
        userImage.imageView!.layer.cornerRadius = userImage.imageView!.frame.size.height / 2
    }
}

