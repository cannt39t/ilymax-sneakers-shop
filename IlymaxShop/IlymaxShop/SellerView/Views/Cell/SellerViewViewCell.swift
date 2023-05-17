//
//  SellerViewViewCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 17.05.2023.
//

import UIKit

class SellerViewViewCell: UICollectionViewCell {
    static let reuseID = String(describing: SellerViewViewCell.self)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var imgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        return imageView
    }()
    
    private var sellerViewPresenterDelegate: SellerViewPresenterDelegate?

    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var transparentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapCell), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        stackView.addArrangedSubview(brandLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()

    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imgImageView)
        stackView.addArrangedSubview(nameStackView)
        contentView.addSubview(transparentButton)
        
        stackView.spacing = 6
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            transparentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transparentButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            transparentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transparentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4
        
    }

    @objc private func didTapCell() {
        sellerViewPresenterDelegate?.showInfo(product: product)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgImageView.image = nil
        brandLabel.text = nil
    }

    var product: Shoes = .init(name: "", description: "", color: "", gender: "", condition: "", data: [], ownerId: "", company: "", category: "")

    func update(product: Shoes, sellerViewPresenterDelegate: SellerViewPresenterDelegate) {
        brandLabel.text = product.company
        nameLabel.text = product.name
        priceLabel.text = "\(product.data[0].price) $"
        self.product = product
        self.sellerViewPresenterDelegate = sellerViewPresenterDelegate
        
        guard let imageUrl = product.imageUrl else {
            // Show error message to user if image URL is nil
            return
        }
        
        StorageManager.shared.getImageUrlFromStorageUrl(imageUrl) { [weak self] error, url in
            guard let self = self else { return } // Make sure self is not nil
            
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            guard let url = url else {
                // Show error message to user if URL is nil
                return
            }
            
            self.loadImage(with: url)
        }
    }

    private func loadImage(with url: URL) {
        imgImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
            } else {
//                if cacheType == .memory || cacheType == .disk {
//                    print("Image loaded from cache")
//                } else {
//                    print("Image loaded from network")
//                }
            }
        }
    }
}
