//
//  OrderCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 31.05.2023.
//

import UIKit


class OrderCell: UICollectionViewCell {
    
    public static let identifier = "OrderCell"
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let quanityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton()
        return button
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
        
        separatorLine.backgroundColor = .separator
    }
    
    
    func setup() {
        setupDesign()
        
        let topStack = UIStackView(arrangedSubviews: [idLabel, dateLabel])
        topStack.distribution = .fill
        
        let bottomStack = UIStackView(arrangedSubviews: [quanityLabel, totalAmountLabel])
        bottomStack.distribution = .fill
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            topStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            separatorLine.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 12),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bottomStack.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 12),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            statusButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            statusButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
