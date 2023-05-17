//
//  AddAddressViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.05.2023.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    public var collectionView: UICollectionView!
    public var presenter: AddAddressPresenter!
    public var saveButton: UIButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Add shipping address"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))

        setupCollectionView()
        setupButton()
    }

    @objc func backButtonTaped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupButton() {
        view.addSubview(saveButton)
        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("Save address", for: .normal)
        saveButton.setTitleColor(.systemBackground, for: .normal)
        saveButton.backgroundColor = .label
        let action = UIAction { [weak self] _ in
//            presenter.saveAddress
            self?.navigationController?.popViewController(animated: true)
        }
        saveButton.addAction(action, for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension AddAddressViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.configureCell("Full name", "Arlene McCoy")
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.configureCell("Address", "25 Robert Latouche Street")
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.keyboardType = .numberPad
                cell.configureCell("Zipcode (Postal Code)", "324545")
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Country", "Choose country")
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("City", "Choose city")
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .secondarySystemBackground
                return cell
        }
    }
}

extension AddAddressViewController: UICollectionViewDelegate {
    
    
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 60, trailing: 12)
        
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
        collectionView.register(AddAddressCell.self, forCellWithReuseIdentifier: AddAddressCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.item {
            case 3:
                print("Go choose country")
            case 4:
                print("Go choose city")
            default:
                print(indexPath)
        }
    }
    
}

