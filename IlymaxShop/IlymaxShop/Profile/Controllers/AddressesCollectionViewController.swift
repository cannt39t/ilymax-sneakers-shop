//
//  AddressesCollectionViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 04.05.2023.
//

import UIKit
import JGProgressHUD

class AddressesCollectionViewController: UIViewController {

    public var collectionView: UICollectionView!
    public var presenter: AddressesPresenter!
    private let loader = JGProgressHUD(style: .light)
    
    public  var noAddressesView: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "You have no addresses"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Addresses"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(push))
        
        
        setupCollectionView()
        view.addSubview(noAddressesView)
        presenter.getAddresses()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noAddressesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noAddressesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAddressesView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func push() {
        presenter.pushAddAddressController()
    }
    
    @objc func backButtonTaped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showLoader() {
        loader.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        loader.dismiss(animated: true)
    }
    
}


extension AddressesCollectionViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
        cell.configureCell()
        return cell
    }
    
}

extension AddressesCollectionViewController: UICollectionViewDelegate {
    
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        setupFirstSection()
    }
    
    
    private func setupFirstSection() -> NSCollectionLayoutSection {
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
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0)
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
        collectionView.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.identifier)
        collectionView.register(AddressHeader.self, forSupplementaryViewOfKind: "HeaderView", withReuseIdentifier: AddressHeader.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: AddressHeader.identifier, for: indexPath) as? AddressHeader else {
            return UICollectionReusableView()
        }
        return view
    }
}

