//
//  HeaderView.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 02.04.2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    private let label = UILabel()
    let showButton = UIButton()
    public var didTapOnHeader: (() -> Void) = {}
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showButton.setTitleColor(.systemBackground, for: .normal)
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        showButton.setImage(image, for: .normal)
        
        label.font = .systemFont(ofSize: 21)
        
         
        // Customize the header view
//        backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [label, showButton])
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
//            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func setTitle(with title: String, hide: Bool) {
        label.text = title
        showButton.isHidden = hide
    }
    
    required init?(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
    }
}

