//
//  PersonalnformationCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//

import UIKit


class PersonalnformationCell: UICollectionViewCell {
    
    public static let identifier = "PersonalnformationCell"
    private let nameLabel: UILabel = .init()
    public let valueTextField: UITextField = .init()
    
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
        
        nameLabel.font = nameLabel.font.withSize(14)
        nameLabel.textColor = .secondaryLabel
        
        valueTextField.font = nameLabel.font.withSize(18)
        valueTextField.textColor = .label
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, valueTextField])
        mainStack.alignment = .leading
        mainStack.spacing = 6
        mainStack.axis = .vertical
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
        ])
    }
    
    public func configureCell(_ name: String, _ value: String) {
        nameLabel.text = name
        valueTextField.text = value
    }
    
}
