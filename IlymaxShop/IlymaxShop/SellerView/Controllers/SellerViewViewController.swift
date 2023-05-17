//
//  SellerViewViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 17.05.2023.
//

import UIKit
import JGProgressHUD

class SellerViewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var presenter: SellerViewPresenter!
    private let hud = JGProgressHUD()
    private let label = UILabel()
    
    private let itemsPerRow: CGFloat = 2
      
    private let minimumItemSpacing: CGFloat = 8
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

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
        self.collectionView.register(SellerViewViewCell.self,
                                      forCellWithReuseIdentifier: SellerViewViewCell.reuseID)
        collectionView.contentInset = .zero
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Seller's profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(moveBack))
        
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeader")

    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected supplementary view kind")
        }

        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeader", for: indexPath) as? CustomHeaderView else {
            fatalError("Unable to dequeue CustomHeaderView")
        }
        
        headerView.setUser(user: presenter.user!)

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
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
    
    @objc private func moveBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SellerViewViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.products.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SellerViewViewCell.reuseID,
                                                            for: indexPath) as? SellerViewViewCell else {
            fatalError("Wrong cell")
        }
        let product = presenter?.products[indexPath.item]
        cell.update(product: product!, sellerViewPresenterDelegate: presenter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = widthPerItem * 1.5
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
}
