//
//  AddressHeader.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 16.05.2023.
//


import UIKit


class AddressHeader: UICollectionReusableView {
    
    public static let identifier = "AddressHeader"
    public var completion: () -> () = {}
    
    public var changeDefaultState: UIButton = .init()
    
    func setupDesign() {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "square")!.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        config.image = image
        config.title = "Use as the shipping address"
        config.baseForegroundColor = .secondaryLabel
        config.imagePadding = 10
        changeDefaultState = UIButton(configuration: config)
        changeDefaultState.contentHorizontalAlignment = .leading
        changeDefaultState.addAction(UIAction(handler: { [weak self] _ in
            self?.completion()
        }), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
        
        backgroundColor = .clear
        let stack = UIStackView(arrangedSubviews: [changeDefaultState])
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    public func makeDefault() {
        let image = UIImage(systemName: "checkmark.square.fill")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        changeDefaultState.configuration?.image = image
        changeDefaultState.configuration?.baseForegroundColor = .label
    }
    
    public func makeNotDefault() {
        let image = UIImage(systemName: "square")!.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        changeDefaultState.configuration?.image = image
        changeDefaultState.configuration?.baseForegroundColor = .secondaryLabel
    }
    
    required init?(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
    }
}
