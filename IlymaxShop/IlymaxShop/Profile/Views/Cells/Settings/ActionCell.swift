//
//  ActionCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//


import UIKit


class ActionCell: UICollectionViewCell {
    
    public static let identifier = "ActionCell"
    private let actionLabel = UILabel()
    public var action: () -> () = {}
    
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
    }
    
    private func setup() {
        setupDesign()
        
        contentView.addSubview(actionLabel)
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(_ text: String, _ color: UIColor) {
        actionLabel.text = text
        actionLabel.textColor = color
    }

}

