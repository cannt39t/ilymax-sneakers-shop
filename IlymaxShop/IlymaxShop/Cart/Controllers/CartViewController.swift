//
//  CartViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var presenter: CartPresenter!
    
    public var products: [Shoes] = []
    
    private var totalPrice: Double = 0
    
    private let emptyCartLabel = UILabel()
    private let emptyCartCatalogButton = UIButton()
    private let totalPriceLabel = UILabel()
    private let buyButton = UIButton()
    private var cartTableView: UITableView!
    
    func setup() {
        view.backgroundColor = .systemBackground
        
        cartTableView = UITableView()
        cartTableView.backgroundColor = .systemBackground
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        view.addSubview(cartTableView)
        cartTableView.isHidden = true
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -16),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        cartTableView.register(CartCell.self, forCellReuseIdentifier: CartCell.indertifier)
        cartTableView.register(CartHeaderView.self, forHeaderFooterViewReuseIdentifier: CartHeaderView.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchData()
        setupView()
        setup()
    }
    
    func setupView() {
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.setTitleColor(.systemBackground, for: .normal)
        buyButton.backgroundColor = .label
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(didTapBuyButton), for: .touchUpInside)
        buyButton.isHidden = true
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        emptyCartLabel.text = "Cart empty"
        emptyCartLabel.font = UIFont.systemFont(ofSize: 20)
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.isHidden = true
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyCartCatalogButton.setTitle("Catalog", for: .normal)
        emptyCartCatalogButton.setTitleColor(.white, for: .normal)
        emptyCartCatalogButton.backgroundColor = .label
        emptyCartCatalogButton.layer.cornerRadius = 10
        emptyCartCatalogButton.addTarget(self, action: #selector(didTapCatalogButton), for: .touchUpInside)
        emptyCartCatalogButton.isHidden = true
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
        if products.count == 0 {
            buyButton.isHidden = true
            emptyCartLabel.isHidden = false
            totalPriceLabel.isHidden = true
            emptyCartCatalogButton.isHidden = false
            cartTableView.isHidden = true
        } else {
            buyButton.isHidden = false
            emptyCartLabel.isHidden = true
            totalPriceLabel.isHidden = false
            emptyCartCatalogButton.isHidden = true
            cartTableView.isHidden = false
            updateTotalPrice()
        }
    }
    
    private func updateTotalPrice(){
        let totalPrice = products.reduce(0.0) { $0 + $1.data[0].price }
        totalPriceLabel.text = "Items in the cart: \(products.count). Total Price: $\(totalPrice)"
    }
    
    // MARK: - Переадресация на платежку
    @objc private func didTapBuyButton() {
        presenter?.buyButtonDidTap()
    }
    
    // MARK: - Возврат в каталог
     @objc private func didTapCatalogButton() {
         tabBarController?.selectedIndex = 0
     }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.indertifier, for: indexPath) as! CartCell
        let product = products[indexPath.row]
        cell.setProduct(product: product)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderView.identifier) as! CartHeaderView
        headerView.configure(title: "Your cart")
        return headerView
    }

    func updateView() {
        start()
        cartTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapOnSection(product: products[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let myDel = UIContextualAction(style: .destructive, title: nil){ [self]
            (_, _, complitionHand) in
            self.presenter.deleteByID(productId: products[indexPath.row].id!)
            self.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            start()
        }
        myDel.image = UIImage(systemName: "trash")
        myDel.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [myDel])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

}
