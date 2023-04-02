//
//  HeaderView.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 02.04.2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    private let label = UILabel()
    private let showButton = UIButton()
    public var didTapOnHeader: (() -> Void) = {}
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showButton.setTitleColor(.black, for: .normal)
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        showButton.setImage(image, for: .normal)
        
         
        // Customize the header view
        backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [label, showButton])
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
     
    required init?(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
    }
}

