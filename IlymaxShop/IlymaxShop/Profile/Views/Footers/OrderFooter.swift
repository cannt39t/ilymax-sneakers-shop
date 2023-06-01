//
//  OrderFooter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.06.2023.
//

import UIKit

class OrderFooter: UICollectionReusableView {
    
    public static let identifier = "OrderFooter"
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [leftLabel, rightLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 12
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0)
        ])
    }
    
    public func setup(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
}
