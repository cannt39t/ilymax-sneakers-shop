//
//  SettingHeader.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 06.05.2023.
//

import UIKit

class SettingHeader: UICollectionReusableView {
    
    private let label = UILabel()
    public static let identifier = "SettingHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        label.font = .systemFont(ofSize: 24, weight: .light)
        let stack = UIStackView(arrangedSubviews: [label])
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    public func setTitle(with title: String) {
        label.text = title
    }
    
    required init?(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
    }
    
}
