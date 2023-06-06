//
//  AddressCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 16.05.2023.
//

import UIKit

class AddressCell: UICollectionViewCell {
    
    public static let identifier = "AddressCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        return label
    }()
    
    private let descryptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let separatorLine: UIView = .init()
    
    
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
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
        
        separatorLine.layer.borderWidth = 1.0
        separatorLine.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func setup() {
        setupDesign()
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, separatorLine, descryptionLabel])
        mainStack.alignment = .leading
        mainStack.spacing = 9
        mainStack.axis = .vertical
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            separatorLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configureCell(with address: IlymaxAddress) {
        nameLabel.text = address.fullName
        descryptionLabel.text = "\(address.country), \(address.city), \(address.zipcode), \(address.address)"
    }
}

