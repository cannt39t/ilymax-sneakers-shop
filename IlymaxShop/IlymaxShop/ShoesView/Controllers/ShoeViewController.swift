//
//  ShoeViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit
import JGProgressHUD

class ShoeViewController: UIViewController {
    
    var presenter: ShoeViewPresenter!
    
    private let hud = JGProgressHUD()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let genderLabel = UILabel()
    private let colorLabel = UILabel()
    private let categoryLabel = UILabel()
    private let conditionLabel = UILabel()
    private let reviewScoreButton = UIButton()
    private let sellerNameButton = UIButton()
    private let reviewCountButton = UIButton()
    private let addToCartButton = UIButton()
    private let detailButton = UIButton()
    private let chatButton = UIButton()
    
    private let stackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.translatesAutoresizingMaskIntoConstraints = false
           return stackView
       }()
       
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "\(presenter.product!.name)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        
        showLoader()
        loadImage()
        presenter.loadReviews()
    }
    
    private func loadImage() {
        guard let shoe = presenter.product, let imageUrlString = shoe.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            fatalError()
        }

        imageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: [.highPriority]) { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
   
    func showLoader() {
        hud.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        hud.dismiss(animated: true)
    }
    
    func updateImage(with image: UIImage?) {
        imageView.image = image
    }
    
    func setupUI() {
        
        addToCartButton.setTitle("Choose Size", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .black
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reviewScoreButton.setTitle(" \(presenter.average)", for: .normal)
        reviewScoreButton.setTitleColor(.black, for: .normal)
        reviewScoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let starImage = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
        reviewScoreButton.setImage(starImage, for: .normal)
        reviewScoreButton.tintColor = .systemYellow
        reviewScoreButton.addTarget(self, action: #selector(reviewScoreButtonTapped), for: .touchUpInside)
        reviewScoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        reviewCountButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        reviewCountButton.setTitleColor(.gray, for: .normal)
        reviewCountButton.addTarget(self, action: #selector(reviewScoreButtonTapped), for: .touchUpInside)
        reviewCountButton.translatesAutoresizingMaskIntoConstraints = false
        
        sellerNameButton.setTitle("\(presenter.sellerName)", for: .normal)
        sellerNameButton.setTitleColor(.black, for: .normal)
        sellerNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        sellerNameButton.addTarget(self, action: #selector(sellerNameButtonTapped), for: .touchUpInside)
        sellerNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        chatButton.setImage(UIImage(systemName: "ellipsis.message.fill"), for: .normal)
        chatButton.tintColor = .black
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genderLabel.font = UIFont.systemFont(ofSize: 16)
        genderLabel.textColor = .darkGray
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorLabel.font = UIFont.systemFont(ofSize: 16)
        colorLabel.textColor = .darkGray
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        categoryLabel.textColor = .darkGray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        conditionLabel.textColor = .darkGray
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailButton.setTitle("Show Details", for: .normal)
        detailButton.setTitleColor(.black, for: .normal)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
        genderLabel.isHidden = true
        colorLabel.isHidden = true
        categoryLabel.isHidden = true
        conditionLabel.isHidden = true
        
        let sizeStackView = UIStackView()
        sizeStackView.axis = .horizontal
        sizeStackView.spacing = 10
        sizeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonSize: CGFloat = 50
                
        for size in presenter.product!.data {
            let button = UIButton()
            let sizeString = size.size.components(separatedBy: " ")[0]
            button.setTitle(sizeString, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.backgroundColor = .gray
            button.translatesAutoresizingMaskIntoConstraints = false
            
//            let availableWidth = sizeStackView.frame.width - (CGFloat(presenter.product!.data.count - 1) * sizeStackView.spacing)
//            let buttonWidth = (availableWidth / CGFloat(presenter.product!.data.count))
            
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.layer.cornerRadius = buttonSize / 2
            
            sizeStackView.addArrangedSubview(button)
            sizeStackView.layoutIfNeeded()
            
            button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        }
        
        let sizeScrollView = UIScrollView()
        sizeScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        sizeScrollView.contentSize = sizeStackView.bounds.size
        sizeScrollView.addSubview(sizeStackView)
        
        nameLabel.text = "\(presenter.product!.company) \(presenter.product!.name)"
        descriptionLabel.text = "\(presenter.product!.description)"
        colorLabel.text = "Color: \(presenter.product!.color)"
        genderLabel.text = "Gender: \(presenter.product!.gender)"
        categoryLabel.text = "Category: \(presenter.product!.category)"
        conditionLabel.text = "Condition: \(presenter.product!.condition)"
        if presenter.reviews.count == 1 {
            reviewCountButton.setTitle("(\(presenter.reviews.count) review)", for: .normal)
        } else {
            reviewCountButton.setTitle("(\(presenter.reviews.count) reviews)", for: .normal)
        }
        
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 5
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        starStackView.addArrangedSubview(reviewScoreButton)
        starStackView.addArrangedSubview(reviewCountButton)
        starStackView.alignment = .leading
        starStackView.distribution = .equalCentering
        
        let sellerStackView = UIStackView()
        sellerStackView.axis = .horizontal
        sellerStackView.spacing = 5
        sellerStackView.translatesAutoresizingMaskIntoConstraints = false
        sellerStackView.addArrangedSubview(sellerNameButton)
        sellerStackView.addArrangedSubview(chatButton)
        sellerStackView.alignment = .leading
        sellerStackView.distribution = .equalCentering
        
        let reviewStackView = UIStackView()
        reviewStackView.axis = .horizontal
        reviewStackView.spacing = 1
        reviewStackView.translatesAutoresizingMaskIntoConstraints = false
        reviewStackView.alignment = .leading
        reviewStackView.distribution = .equalCentering
        reviewStackView.addArrangedSubview(starStackView)
        reviewStackView.addArrangedSubview(sellerStackView)
        
        view.addSubview(addToCartButton)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(reviewStackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(sizeScrollView)
        stackView.addArrangedSubview(detailButton)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(colorLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(conditionLabel)
        
        NSLayoutConstraint.activate([
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 48),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -20),
        
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            
            sizeScrollView.heightAnchor.constraint(equalToConstant: buttonSize + 20),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            reviewStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            reviewStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            reviewCountButton.centerYAnchor.constraint(equalTo: reviewScoreButton.centerYAnchor),
            sellerNameButton.centerYAnchor.constraint(equalTo: reviewScoreButton.centerYAnchor),
            chatButton.centerYAnchor.constraint(equalTo: reviewScoreButton.centerYAnchor),
            chatButton.trailingAnchor.constraint(equalTo: reviewStackView.trailingAnchor),
            sellerNameButton.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -5),
            sellerNameButton.leadingAnchor.constraint(equalTo: reviewStackView.centerXAnchor)
        ])
    }
    
    @objc private func reviewScoreButtonTapped() {
        presenter.pushReviews()
    }
    
    @objc private func sellerNameButtonTapped() {
        showLoader()
        presenter.pushSeller()
    }
    
    @objc private func chatButtonTapped() {
        print("Chat")
    }
    
    @objc private func didTapAddToCartButton() {
        if addToCartButton.titleLabel?.text != "Choose Size" {
            let price = Float( (addToCartButton.titleLabel?.text!.replacingOccurrences(of: " $", with: ""))!)

            let ilymaxCartItem = IlymaxCartItem(id: presenter.product!.id!, name: presenter.product!.name, description: presenter.product!.description, color: presenter.product!.color, gender: presenter.product!.gender, condition: presenter.product!.condition, imageUrl: presenter.product!.imageUrl!, data: ShoesDetail(size: "\(selectedButton?.titleLabel?.text ?? "") EU", price: price!, quantity: 1), ownerId: presenter.product!.ownerId, company: presenter.product!.company, category: presenter.product!.category)
            
            presenter.addToCart(cartItem: ilymaxCartItem)
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    var selectedButton: UIButton? {
        didSet {
            if let size = selectedButton?.title(for: .normal) {
                for shoesDetail in presenter.product!.data {
                    if shoesDetail.size == "\(size) EU" {
                        addToCartButton.setTitle("\(shoesDetail.price) $", for: .normal)
                    }
                }
            } else {
                addToCartButton.setTitle("Add to Cart", for: .normal)
            }
        }
    }

    @objc func sizeButtonTapped(_ sender: UIButton) {
        selectedButton?.backgroundColor = .gray
        
        sender.backgroundColor = .black
        selectedButton = sender
    }
    
    @objc func detailButtonTapped(_ sender: UIButton) {
        let isHidden = genderLabel.isHidden
        genderLabel.isHidden = !isHidden
        colorLabel.isHidden = !isHidden
        categoryLabel.isHidden = !isHidden
        conditionLabel.isHidden = !isHidden
        
        let title = isHidden ? "Hide Details" : "Show Details"
        detailButton.setTitle(title, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height), animated: true)
        }
    }
}
