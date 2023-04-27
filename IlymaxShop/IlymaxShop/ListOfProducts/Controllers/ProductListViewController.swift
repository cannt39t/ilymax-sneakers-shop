//
//  ProductListViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

class ProductListViewController: UICollectionViewController {

    var presenter: ProductListPresenter!

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
                                      forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseID)
        collectionView.contentInset = .zero
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        updatePresentationStyle()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "\(presenter.name)"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(moveBack))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout)), UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(filter))]
        }
    
    private func isEmpty() {
        if presenter.products.count == 0 {
            let label = UILabel()
            label.text = "Sorry, nothing was found"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 17)
            view.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    @objc private func filter() {
        let modalFilterViewController = ModalFilterViewController()
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
        return presenter?.products.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.reuseID,
                                                            for: indexPath) as? ProductListCollectionViewCell else {
            fatalError("Wrong cell")
        }
        let product = presenter?.products[indexPath.item]
        cell.update(product: product!, productListPresenterDelegate: presenter)
        return cell
    }
    
}
