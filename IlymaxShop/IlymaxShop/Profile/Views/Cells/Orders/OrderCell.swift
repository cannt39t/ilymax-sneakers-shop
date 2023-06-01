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
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
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
        topStack.distribution = .equalCentering
        
        let bottomStack = UIStackView(arrangedSubviews: [quanityLabel, totalAmountLabel])
        bottomStack.distribution = .equalCentering
        
        let statusStack = UIStackView(arrangedSubviews: [statusImageView, statusLabel])
        statusStack.spacing = 12
        
        contentView.addSubview(topStack)
        contentView.addSubview(separatorLine)
        contentView.addSubview(bottomStack)
        contentView.addSubview(statusStack)
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        statusStack.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            statusStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            statusStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    func configureWith(order: IlymaxOrder) {
        idLabel.text = "Order No\(order.id)"
        dateLabel.text = OrderCell.dateFormatter.string(from: order.date)

        quanityLabel.attributedText = getAttributedString(firstPart: "Quanity:", secondPart: "\(order.items.count)")
        
        print(order.address)
        let totalAmount: Float = order.items.reduce(0) { $0 + $1.data.price }
        totalAmountLabel.attributedText = getAttributedString(firstPart: "Total Amount:", secondPart: "$\(Int(totalAmount))")
        
        switch order.status {
            case "Processing":
                statusLabel.text = "Processing"
                statusLabel.textColor = .systemYellow
                statusImageView.image = UIImage(systemName: "clock")?.withTintColor(.label, renderingMode: .alwaysOriginal)
                statusImageView.isHidden = false
            case "Delivered":
                statusLabel.text = "Delivered"
                statusLabel.textColor = .green
                statusImageView.isHidden = true
            case "Canceled":
                statusLabel.text = "Canceled"
                statusLabel.textColor = .red
                statusImageView.isHidden = true
            default:
                statusLabel.isHidden = true
                statusImageView.isHidden = true
        }
    }
    
    func getAttributedString(firstPart: String, secondPart: String) -> NSMutableAttributedString {
        let quantityString = firstPart
        let quantityAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        let quantityAttributedString = NSAttributedString(string: quantityString, attributes: quantityAttributes)
        
        let quantityValueString = secondPart
        let quantityValueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label
        ]
        let quantityValueAttributedString = NSAttributedString(string: quantityValueString, attributes: quantityValueAttributes)
        
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(quantityAttributedString)
        combinedAttributedString.append(NSAttributedString(string: " "))
        combinedAttributedString.append(quantityValueAttributedString)
        
        return combinedAttributedString
    }
    
}
