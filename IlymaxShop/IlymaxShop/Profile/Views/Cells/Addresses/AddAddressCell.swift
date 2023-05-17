//
//  AddAddressCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.05.2023.
//

import UIKit


class AddAddressCell: UICollectionViewCell {
    
    public static let identifier = "AddAddressCell"
    private let nameLabel: UILabel = .init()
    public let valueTextField: UITextField = .init()
    public let forwardImage: UIImageView =  .init(image: UIImage(systemName: "chevron.forward")!.withTintColor(.label, renderingMode: .alwaysOriginal))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    private func setupDesign() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.secondaryLabel.cgColor
        
        nameLabel.font = nameLabel.font.withSize(14)
        nameLabel.textColor = .secondaryLabel
        
        valueTextField.font = nameLabel.font.withSize(18)
        valueTextField.textColor = .label
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
        
        forwardImage.isHidden = true
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, valueTextField])
        mainStack.alignment = .leading
        mainStack.spacing = 6
        mainStack.axis = .vertical
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        forwardImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        contentView.addSubview(forwardImage)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            mainStack.trailingAnchor.constraint(equalTo: forwardImage.leadingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            
            forwardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            forwardImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configureCell(_ name: String, _ value: String) {
        nameLabel.text = name
        valueTextField.text = value
    }
    
}
