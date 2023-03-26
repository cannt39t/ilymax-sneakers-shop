//
//  HeaderView.swift
//  CompositionalLayoutGoodExample
//
//  Created by Илья Казначеев on 24.02.2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    private let label = UILabel()
    private let showButton = UIButton()
    public var didTapOnHeader: (() -> Void) = {}
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        showButton.setTitleColor(.black, for: .normal)
         
        // Customize the header view
        backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [label, showButton])
        stack.distribution = .fill
        
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
    
    var buttonTitle: String? {
        didSet {
            showButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
     
    required init?(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
    }
}
