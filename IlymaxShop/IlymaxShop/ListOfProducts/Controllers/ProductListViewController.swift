//
//  ProductListViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class ProductListViewController: UICollectionViewController {

    var presenter: ProductListPresenter!
    private let hud = JGProgressHUD()
    private let label = UILabel()
    
    private enum PresentationStyle: String, CaseIterable {
        case table
        case defaultGrid

        var buttonImage: UIImage {
            switch self {
            case .table: return UIImage(systemName: "rectangle.grid.1x2")!
            case .defaultGrid: return UIImage(systemName: "square.grid.2x2")!
            }
        }
    }

    private var selectedStyle: PresentationStyle = .defaultGrid {
        didSet { updatePresentationStyle() }
    }

    private var styleDelegates: [PresentationStyle: CollectionViewSelectableItemDelegate] = {
            let result: [PresentationStyle: CollectionViewSelectableItemDelegate] = [
                .table: TabledContentCollectionViewDelegate(),
                .defaultGrid: DefaultGriddedContentCollectionViewDelegate(),
            ]
            result.values.forEach {
                $0.didSelectItem = { _ in
                    print("Item selected")
                }
            }
            return result
        }()

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEmpty()
        self.collectionView.register(ProductListCollectionViewCell.self,
                                      forCellWithReuseIdentifier: ProductListCollectionViewCell.identifier)
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .systemGroupedBackground
        updatePresentationStyle()
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "\(presenter.name)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(moveBack))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout)), UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(filter))]
    }
    
    func showLoader() {
        hud.show(in: self.view, animated: true)
        isEmpty()
    }
    
    func hideLoader() {
        hud.dismiss(animated: true)
    }
    
    func isEmpty() {
        label.text = "Sorry, nothing was found"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if presenter.products.count == 0 {
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    @objc private func filter() {
        let modalFilterViewController = ModalFilterViewController()
        modalFilterViewController.presenter = presenter
        navigationController?.present(modalFilterViewController, animated: true)
    }
    
    @objc private func moveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updatePresentationStyle() {
        collectionView.delegate = styleDelegates[selectedStyle]
        collectionView.performBatchUpdates( {
            collectionView.reloadData()
        }, completion: nil)

        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
    }

    @objc private func changeContentLayout() {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count
        selectedStyle = allCases[nextIndex]
    }
    
}

extension ProductListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.identifier,
                                                            for: indexPath) as? ProductListCollectionViewCell else {
            fatalError("Wrong cell")
        }
        let product = presenter?.products[indexPath.item]
        cell.update(product: product!, productListPresenterDelegate: presenter)
        if let userId = FirebaseAuth.Auth.auth().currentUser.uid {
            if product!.ownerId == userId {
                cell.cartButton.isHidden = true
            }
        }
        return cell
    }
    
}
