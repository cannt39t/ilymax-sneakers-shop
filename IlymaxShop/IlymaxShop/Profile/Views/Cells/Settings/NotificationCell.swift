//
//  NotificationCell.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 15.05.2023.
//

import UIKit


class NotificationCell: UICollectionViewCell {
    
    public static let identifier = "NotificationCell"
    private let nameLabel: UILabel = .init()
    public let toggle: UISwitch = .init()
    var completion: (String, Bool) -> () = { _,_ in}
    
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
        
        nameLabel.font = nameLabel.font.withSize(18)
        nameLabel.textColor = .label
        
        let lightView = UIView(frame: bounds)
        lightView.backgroundColor = .secondarySystemGroupedBackground
        self.backgroundView = lightView
        
        let grayView = UIView(frame: bounds)
        grayView.backgroundColor = .lightGray.withAlphaComponent(0.25)
        self.selectedBackgroundView = grayView
    }
    
    private func setup() {
        setupDesign()
        toggle.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, toggle])
        mainStack.alignment = .leading
        mainStack.spacing = 6
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: toggle.centerYAnchor),
        ])
    }
    
    @objc func valueChange(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        completion(nameLabel.text!, value)
        print("switch value changed \(value)")
    }
    
    public func setName(_ text: String) {
        nameLabel.text = text
    }
}
