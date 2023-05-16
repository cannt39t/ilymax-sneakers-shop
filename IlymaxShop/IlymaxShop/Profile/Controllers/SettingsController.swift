//
//  SettingsController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import UIKit
import JGProgressHUD


class SettingsController: UIViewController {
    
    public var collectionView: UICollectionView!
    public var presenter: SettingsPresenter!
    private let loader = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Settings"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))
        
        //        showLoader()
        setupCollectionView()
        //        presenter.fetchSettings()
    }
    
    @objc func backButtonTaped() {
        presenter.backButtonTap()
    }
    
    func showLoader() {
        loader.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        loader.dismiss(animated: true)
    }
    
    func showSucces() {
        loader.indicatorView = JGProgressHUDSuccessIndicatorView()
        loader.textLabel.text = "Success"
        loader.show(in: self.view, animated: true)
        loader.dismiss(afterDelay: 1.0)
    }
    
}

extension SettingsController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 1:
                return 1
            case 2:
                return 3
            case 3:
                return 3
            case 4:
                return 2
            default:
                return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                switch indexPath.item {
                    case 0:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalnformationCell.identifier, for: indexPath) as! PersonalnformationCell
                        cell.configureCell("Name", presenter.currentUser.name)
                        return cell
                    case 1:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalnformationCell.identifier, for: indexPath) as! PersonalnformationCell
                        cell.configureCell("Email", presenter.currentUser.emailAddress)
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .secondarySystemBackground
                        return cell
                }
            case 1:
                switch indexPath.item {
                    case 0:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PasswordCell.identifier, for: indexPath) as! PasswordCell
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .secondarySystemBackground
                        return cell
                }
            case 2:
                switch indexPath.item {
                    case 0:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
                        cell.setName("Sales")
                        return cell
                    case 1:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
                        cell.setName("Messages")
                        return cell
                    case 2:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
                        cell.setName("Delivery status changes")
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .secondarySystemBackground
                        return cell
                }
            case 3:
                switch indexPath.item {
                    case 0:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelpCenterCell.identifier, for: indexPath) as! HelpCenterCell
                        cell.setName("FAQ")
                        return cell
                    case 1:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelpCenterCell.identifier, for: indexPath) as! HelpCenterCell
                        cell.setName("Contact Us")
                        return cell
                    case 2:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelpCenterCell.identifier, for: indexPath) as! HelpCenterCell
                        cell.setName("Privacy & Terms")
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .secondarySystemBackground
                        return cell
                }
            case 4:
                switch indexPath.item {
                    case 0:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCell.identifier, for: indexPath) as! ActionCell
                        cell.configure("Clear cache", .systemBlue)
                        return cell
                    case 1:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCell.identifier, for: indexPath) as! ActionCell
                        cell.configure("Sign out", .red)
                        return cell
                    default:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                        cell.backgroundColor = .secondarySystemBackground
                        return cell
                }
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .secondarySystemBackground
                return cell
        }
    }
}

extension SettingsController: UICollectionViewDelegate {
    
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
            case 4:
                return actionSection()
            default:
                return setupFirstSection()
        }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        //supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func actionSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 6, trailing: 12)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 24, trailing: 12)
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            case 0:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier, for: indexPath) as? SettingHeader else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Personal information")
                return view
            case 1:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier, for: indexPath) as? SettingHeader else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Password")
                return view
            case 2:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier, for: indexPath) as? SettingHeader else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Notification")
                return view
            case 3:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier, for: indexPath) as? SettingHeader else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Help center")
                return view
            default:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier, for: indexPath) as? SettingHeader else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "")
                return view
        }
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
        collectionView.register(SettingHeader.self, forSupplementaryViewOfKind: "HeaderView", withReuseIdentifier: SettingHeader.identifier)
        collectionView.register(PersonalnformationCell.self, forCellWithReuseIdentifier: PersonalnformationCell.identifier)
        collectionView.register(PasswordCell.self, forCellWithReuseIdentifier: PasswordCell.identifier)
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.identifier)
        collectionView.register(HelpCenterCell.self, forCellWithReuseIdentifier: HelpCenterCell.identifier)
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: ActionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
            case 4 :
                switch indexPath.item {
                    case 0 :
                        presenter.clearCache()
                    case 1 :
                        presenter.signOut()
                    default:
                        print(indexPath)
                }
            default:
                print(indexPath)
        }
    }
    
}
