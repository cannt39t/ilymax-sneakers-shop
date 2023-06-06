//
//  ReviewTableViewCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 24.04.2023.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    let nameLabel = UILabel()

    let starsStackView = UIStackView()

    let dateLabel = UILabel()

    let reviewLabel = UILabel()

    let reviewImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        starsStackView.axis = .horizontal
        starsStackView.spacing = 4
        starsStackView.alignment = .leading
        starsStackView.distribution = .fillProportionally

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .gray

        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        reviewLabel.numberOfLines = 0

        reviewImageView.translatesAutoresizingMaskIntoConstraints = false
        reviewImageView.contentMode = .scaleAspectFill
        

        let imageAndNameStackView = UIStackView(arrangedSubviews: [reviewImageView, nameLabel])
        imageAndNameStackView.translatesAutoresizingMaskIntoConstraints = false
        imageAndNameStackView.axis = .horizontal
        imageAndNameStackView.spacing = 8

        let starsAndDateStackView = UIStackView(arrangedSubviews: [starsStackView, dateLabel])
        starsAndDateStackView.translatesAutoresizingMaskIntoConstraints = false
        starsAndDateStackView.axis = .horizontal
        starsAndDateStackView.spacing = 4

        let mainStackView = UIStackView(arrangedSubviews: [imageAndNameStackView, starsAndDateStackView, reviewLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            reviewImageView.widthAnchor.constraint(equalToConstant: 80),
            reviewImageView.heightAnchor.constraint(equalToConstant: 80),

            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            starsStackView.heightAnchor.constraint(equalToConstant: 20)
       ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reviewImageView.layer.cornerRadius = reviewImageView.frame.width / 2
        reviewImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with review: IlymaxReview, name: String, imageURL: String?) {
        nameLabel.text = name
        reviewImageView.image = UIImage(systemName: "photo")
        
        if let imageURLString = imageURL, let imageURL = URL(string: imageURLString) {
            loadImage(with: imageURL)
        } else {
            let profileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
            reviewImageView.image = profileImage
        }
        
        dateLabel.text = "\(review.date.formatted(date: .complete, time: .omitted))"
        reviewLabel.text = review.text

        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 0..<5 {
            let starImageView = UIImageView(image: i < review.rate ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
            starImageView.contentMode = .center
            starImageView.tintColor = UIColor.systemYellow
            starsStackView.addArrangedSubview(starImageView)
        }
    }
    
    private func loadImage(with url: URL) {
        reviewImageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
