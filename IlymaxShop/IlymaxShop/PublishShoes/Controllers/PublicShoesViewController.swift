//
//  PublicShoesViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class PublicShoesViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    let genders = ["MAN", "WOMAN", "UNISEX"]
    let companies = ["ILYMAX", "Nike", "Adidas", "Vans", "Timberland", "Puma", "Crocs", "Reebok", "Converse", "Lacoste", "Jordan", "Barbour", "TODS", "Brioni", "Gucci", "Diesel", "New Balance", "Ocai", "Diadora", "DrMartens", "Asics", "Boss", "Salomon", "UGG"]
    let colors = [ "Black", "Blue", "Brown", "Gold", "Green", "Grey", "Multi", "Navy", "Neutral", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow"]
    let conditions = ["NEW", "PiU"]
    
    public var collectionView: UICollectionView!
    var presenter: PublicShoesPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Adding"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(moveForward))

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        setupCollectionView()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @objc private func moveForward() {
        var isValid = true
        var arguments = [String]()
        for item in 0..<7 {
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as! AddAddressCell
            guard let text = cell.valueTextField.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
                cell.makeInvalid()
                isValid = false
                continue
            }
            arguments.append(text)
            cell.makeValid()
        }
        if isValid {
            presenter.product.name = arguments[0]
            presenter.product.description = arguments[1]
            presenter.product.gender = arguments[2]
            presenter.product.company = arguments[3]
            presenter.product.color = arguments[4]
            presenter.product.category = arguments[5]
            presenter.product.condition = arguments[6]
            let sizeAddVC = PublicShoesSizeViewController()
            sizeAddVC.presenter = presenter
            self.navigationController?.pushViewController(sizeAddVC, animated: true)
        }
    }
}

extension PublicShoesViewController: UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Enter name"
                if presenter.product.name != "" {
                    cell.valueTextField.text = presenter.product.name
                }
                cell.valueTextField.delegate = self
                cell.valueTextField.resignFirstResponder()
                cell.configureCell("Name", "")
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Enter description"
                if presenter.product.description != "" {
                    cell.valueTextField.text = presenter.product.description
                }
                cell.valueTextField.delegate = self
                cell.valueTextField.resignFirstResponder()
                cell.configureCell("Description", "")
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Choose gender"
                if presenter.product.gender != "" {
                    cell.valueTextField.text = presenter.product.gender
                }
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Gender", "")
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Choose company"
                if presenter.product.company != "" {
                    cell.valueTextField.text = presenter.product.company
                }
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Company", "")
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Choose color"
                if presenter.product.color != "" {
                    cell.valueTextField.text = presenter.product.color
                }
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Color", "")
                return cell
            case 5:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Choose category"
                if presenter.product.category != "" {
                    cell.valueTextField.text = presenter.product.category
                }
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Category", "")
                return cell
            case 6:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCell.identifier, for: indexPath) as! AddAddressCell
                cell.valueTextField.placeholder = "Choose condition"
                if presenter.product.condition != "" {
                    cell.valueTextField.text = presenter.product.condition
                }
                cell.valueTextField.isEnabled = false
                cell.forwardImage.isHidden = false
                cell.configureCell("Condition", "")
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .secondarySystemBackground
                return cell
            }
        
    }

}

extension PublicShoesViewController: UICollectionViewDelegate {


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

    func setupCollectionView() {
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
            case 2:
                let vc = ChooseViewController()
                vc.data = genders
                vc.textForTitle = "gender"
                vc.completion = { data in
                    let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                    cell.valueTextField.text = data
                }
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = ChooseViewController()
                vc.data = companies
                vc.textForTitle = "companie"
                vc.completion = { data in
                    let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                    cell.valueTextField.text = data
                }
                navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = ChooseViewController()
                vc.data = colors
                vc.textForTitle = "color"
                vc.completion = { data in
                    let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                    cell.valueTextField.text = data
                }
                navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = ChooseViewController()
                vc.data = presenter.categories
                vc.textForTitle = "category"
                vc.completion = { data in
                   let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                   cell.valueTextField.text = data
               }
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                let vc = ChooseViewController()
                vc.data = conditions
                vc.textForTitle = "condition"
                vc.completion = { data in
                    let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                    cell.valueTextField.text = data
                }
                navigationController?.pushViewController(vc, animated: true)
            default:
                let cell = collectionView.cellForItem(at: indexPath) as! AddAddressCell
                cell.valueTextField.becomeFirstResponder()
        }
    }
}
