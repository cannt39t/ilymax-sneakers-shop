//
//  ProductListCollectionViewCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ProductListCollectionViewCell.self)

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
    
    public lazy var cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCart), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapCart() {
        productListPresenterDelegate?.modalAdding(product: product)
    }
    
    private var productListPresenterDelegate: ProductListPresenterDelegate?

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

    public lazy var transparentButton: UIButton = {
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

        backgroundColor = .secondarySystemGroupedBackground
        clipsToBounds = true
        layer.cornerRadius = 4
        
        contentView.addSubview(cartButton)
            NSLayoutConstraint.activate([
                cartButton.widthAnchor.constraint(equalToConstant: 20),
                cartButton.heightAnchor.constraint(equalToConstant: 20),
                cartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
    }

    @objc private func didTapCell() {
        productListPresenterDelegate?.showInfo(product: product)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgImageView.image = nil
        brandLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentStyle()
    }

    var product: Shoes = .init(name: "", description: "", color: "", gender: "", condition: "", data: [], ownerId: "", company: "", category: "")

    func update(product: Shoes, productListPresenterDelegate: ProductListPresenterDelegate?) {
        brandLabel.text = product.company
        nameLabel.text = product.name
        priceLabel.text = "\(product.data[0].price) $"
        self.product = product
        self.productListPresenterDelegate = productListPresenterDelegate
        
        guard let imageUrlString = product.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            // Show error message to user if image URL is nil
            return
        }
        
        loadImage(with: imageUrl)
    }

    private func loadImage(with url: URL) {
        imgImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                // Show error message to user
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }

    private func updateContentStyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        guard oldAxis != newAxis else { return }
        stackView.axis = newAxis
        stackView.spacing = isHorizontalStyle ? 16 : 4
    }
}
