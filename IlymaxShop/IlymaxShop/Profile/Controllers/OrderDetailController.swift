//
//  OrderDetailController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.06.2023.
//

import UIKit


extension OrderDetailController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class OrderDetailController: UIViewController {
    
    public var collectionView: UICollectionView!
    public var order: IlymaxOrder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Order details"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupCollectionView()
        collectionView.reloadData()
    }
    
    @objc func backButtonTaped() {
        navigationController?.popViewController(animated: true)
    }
}


extension OrderDetailController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == order.items.count || section == order.items.count + 1 {
            return 0
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        order.items.count + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < order.items.count + 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderItemCell.identifier, for: indexPath) as! OrderItemCell
            cell.configure(with: order.items[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
            cell.configureCell(with: order.address)
            return cell
        }
    }
}

extension OrderDetailController: UICollectionViewDelegate {
    
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        if index < order.items.count + 2 {
            return setupFirstSection()
        } else {
            return setupAddressSection()
        }
    }
    
    
    private func setupFirstSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        //supplementary
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: "FooterView", alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    
    private func setupAddressSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(155))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        //supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "FooterView", alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(OrderItemCell.self, forCellWithReuseIdentifier: OrderItemCell.identifier)
        collectionView.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.identifier)
        collectionView.register(OrderFooter.self, forSupplementaryViewOfKind: "FooterView", withReuseIdentifier: OrderFooter.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section < order.items.count + 2 {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "FooterView", withReuseIdentifier: OrderFooter.identifier, for: indexPath) as? OrderFooter else {
                return UICollectionReusableView()
            }
            if indexPath.section < order.items.count {
                let data = order.items[indexPath.item].data
                view.setup(leftText: "$\(data.price)", rightText: "Size: \(data.size)")
            } else if indexPath.section == order.items.count {
                view.setup(leftText: "$30", rightText: "Shipping")
            } else if indexPath.section == order.items.count + 1 {
                let totalAmount: Float = order.items.reduce(0) { $0 + $1.data.price }
                view.setup(leftText: "Total: $\(Int(totalAmount + 30))", rightText: "")
            }
            return view
        } else {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "FooterView", withReuseIdentifier: OrderFooter.identifier, for: indexPath) as? OrderFooter else {
                return UICollectionReusableView()
            }
            view.setup(leftText: "Delivery Address: ", rightText: "")
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
