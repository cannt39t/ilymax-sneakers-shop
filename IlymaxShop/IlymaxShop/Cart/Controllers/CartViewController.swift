//
//  CartViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - делаем CompositionLayout
    var presenter: CartPresenter!
    
    private var totalPrice: Double = 0
    
    private let emptyCartLabel = UILabel()
    private let emptyCartCatalogButton = UIButton()
    private let totalPriceLabel = UILabel()
    private let buyButton = UIButton()
    private var cartCollectionView: UICollectionView!
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width / 1, height: view.frame.height / 5)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        cartCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cartCollectionView.backgroundColor = .white
        cartCollectionView.delegate = self
        
        view.addSubview(cartCollectionView)

        cartCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartCollectionView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -16),
            cartCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        cartCollectionView.register(CartCell.self, forCellWithReuseIdentifier: CartCell.indertifier)
        cartCollectionView.register(CartHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CartHeaderView.identifier)
        cartCollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter!.getProducts()
        setupView()
        setup()
        start()
    }
    
    private func setupView() {
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.backgroundColor = .black
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(didTapBuyButton), for: .touchUpInside)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        emptyCartLabel.text = "Cart empty"
        emptyCartLabel.font = UIFont.systemFont(ofSize: 20)
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.isHidden = true
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyCartCatalogButton.setTitle("Catalog", for: .normal)
        emptyCartCatalogButton.setTitleColor(.white, for: .normal)
        emptyCartCatalogButton.backgroundColor = .black
        emptyCartCatalogButton.layer.cornerRadius = 10
        emptyCartCatalogButton.addTarget(self, action: #selector(didTapCatalogButton), for: .touchUpInside)
        emptyCartCatalogButton.translatesAutoresizingMaskIntoConstraints = false
        
        totalPriceLabel.textAlignment = .left
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buyButton)
        view.addSubview(emptyCartLabel)
        view.addSubview(emptyCartCatalogButton)
        view.addSubview(totalPriceLabel)
        
        // MARK: - Constraints!
        NSLayoutConstraint.activate([
            
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyButton.heightAnchor.constraint(equalToConstant: 48),
                
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyCartLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
            emptyCartCatalogButton.bottomAnchor.constraint(equalTo: emptyCartLabel.bottomAnchor, constant: 50),
            emptyCartCatalogButton.leadingAnchor.constraint(equalTo: emptyCartLabel.leadingAnchor, constant: 16),
            emptyCartCatalogButton.trailingAnchor.constraint(equalTo: emptyCartLabel.trailingAnchor, constant: -16),
                
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalPriceLabel.topAnchor.constraint(equalTo: buyButton.topAnchor, constant: -30),
        ])
    }
    
    private func start() {
        if presenter?.products.count ?? 0 == 0 {
            buyButton.isHidden = true
            emptyCartLabel.isHidden = false
            totalPriceLabel.isHidden = true
            emptyCartCatalogButton.isHidden = false
            cartCollectionView.isHidden = true
        } else {
            updateTotalPrice()
            buyButton.isHidden = false
            emptyCartLabel.isHidden = true
            totalPriceLabel.isHidden = false
            emptyCartCatalogButton.isHidden = true
            cartCollectionView.isHidden = false
            updateTotalPrice()
        }
    }
    
    private func updateTotalPrice(){
        totalPrice = presenter?.products.reduce(0.0) { $0 + $1.price } ?? 0
        totalPriceLabel.text = "Items in the cart: \(presenter?.products.count ?? 0). Total Price: $\(totalPrice)"
    }
    
    // MARK: - Переадресация на платежку
    @objc private func didTapBuyButton() {
        presenter?.buyButtonDidTap()
    }
    
    // MARK: - Возврат в каталог
     @objc private func didTapCatalogButton() {
         tabBarController?.selectedIndex = 0
     }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCell.indertifier, for: indexPath) as! CartCell
        let product = presenter?.products[indexPath.item]
        cell.setProduct(product: product!, cartPresenterDelegate: presenter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CartHeaderView.identifier, for: indexPath) as! CartHeaderView
            headerView.configure(title: "Your cart")
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    func updateView(){
        start()
        cartCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapOnSection(productId: (presenter?.products[indexPath.item].id)!)
    }
}
