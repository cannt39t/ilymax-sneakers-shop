//
//  ConversationTableViewCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.04.2023.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        let topStack = UIStackView(arrangedSubviews: [userNameLabel, dateLabel])
        topStack.axis = .horizontal
        topStack.spacing = 6
        topStack.distribution = .fill
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, userMessageLabel])
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        
        contentView.addSubview(userImageView)
        contentView.addSubview(mainStack)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            mainStack.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }
    
    public func configure(with conversation: Conversation) {
        DispatchQueue.global(qos: .utility).async {
            StorageManager.shared.getImageUrlFromStorageUrlProfileByEmail(email: conversation.otherUserEmail) { [weak self] url in
                print(url?.absoluteString ?? "ytne")
                if let url {
                    self?.configureImage(with: url)
                } else {
                    
                }
            }
        }
        
        let dateConversation = DateFormatter.dateFormatter.date(from: conversation.latestMessage.date)!
        let formattedString = DateFormatter.conversationListFormattedString(from: dateConversation)
        userMessageLabel.text = conversation.latestMessage.text
        userNameLabel.text = conversation.name
        dateLabel.text = formattedString
    }
    
    private func configureImage(with url: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.userImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}
