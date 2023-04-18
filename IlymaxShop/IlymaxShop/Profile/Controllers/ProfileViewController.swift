//
//  ProfileViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit
import JGProgressHUD



class ProfileViewController: UIViewController {
    
    public var collectionView: UICollectionView!
    public var presenter: ProfilePresenter!
    private var currentUser: IlymaxUser?
    private let hud = JGProgressHUD()
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
        presenter.fetchUser()
    }
    
    public func showUserProfile(with user: IlymaxUser) {
        currentUser = user
        print(user)
        setupCollectionView()
        hideLoader()
    }
    
    
    public func somethingWentWrong() {
        print("Something went wrong")
        hideLoader()
        
        //TODO: Show view that somwthing went wrong
    }
    
    
    func showLoader() {
        hud.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        hud.dismiss(animated: true)
    }
    
}
    
extension ProfileViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 4
            default:
                return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.identifier, for: indexPath) as! UserCell
                userCell.setUser(user: currentUser!)
                userCell.userImage.addTarget(self, action: #selector(tapOnImage), for: .touchUpInside)
                
                return userCell
            case 1:
                let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
                switch indexPath.item {
                    case 0:
                        profileCell.configure(with: "My orders", "Already have \(presenter.getOrders()) orders")
                    case 1:
                        profileCell.configure(with: "My listings for sale", "\(presenter.getListingsForSale()) Items")
                    case 2:
                        profileCell.configure(with: "Shipping addresses", "\(presenter.getAddresses()) Addresses")
                    case 3:
                        profileCell.configure(with: "Setting", "Notification, Password, FAQ, Contact")
                    default:
                        profileCell.configure(with: "", "")
                }
                return profileCell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
                return cell
        }
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
            case 0: return setupFirstSection()
            case 1: return setupSecondSection()
            default: return setupFirstSection()
        }
    }
    
    
    private func setupFirstSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 80, leading: 24, bottom: 24, trailing: 24)
        
        return section
    }
    
    private func setupSecondSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 0, bottom: 9, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 24, trailing: 24)
        
        return section
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                print(0)
            case 1:
                print(1)
            default:
                print(indexPath)
        }
    }
    
    @objc private func tapOnImage() {
        let alert = UIAlertController(title: "Choose profile image", message: nil, preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Library", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let indexPath = IndexPath(row: 0, section: 0) // Change row and section according to your requirement
            let userCell = collectionView.cellForItem(at: indexPath) as! UserCell
            if let image = pickedImage.fixedOrientation() {
                print("Fixed image orientation")
                userCell.setImageProfile(image)
                presenter.uploadProfileImage(image)
            } else {
                userCell.setImageProfile(pickedImage)
                presenter.uploadProfileImage(pickedImage)
            }
        }
        dismiss(animated: true)
    }
}
