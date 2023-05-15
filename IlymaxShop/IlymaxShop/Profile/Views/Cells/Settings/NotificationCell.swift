//
//  NotificationCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//

import UIKit


class NotificationCell: UICollectionViewCell {
    
    public static let identifier = "NotificationCell"
    private let nameLabel: UILabel = .init()
    private let toggle: UISwitch = .init()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        nameLabel.font = nameLabel.font.withSize(18)
        nameLabel.textColor = .label
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, toggle])
        mainStack.alignment = .leading
        mainStack.spacing = 6
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: toggle.centerYAnchor),
        ])
    }
    
    public func setName(_ text: String) {
        nameLabel.text = text
    }
}
