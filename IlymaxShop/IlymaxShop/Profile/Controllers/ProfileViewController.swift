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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        showLoader()
        presenter.fetchUserAndData()
    }
    
    public func showUserProfile(with user: IlymaxUser) {
        currentUser = user
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
    
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: error.localizedDescription, message: "Something went wrong, Please wait for some time", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Okay, i'll try it later", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
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
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage(_:)))
                userCell.userImageView.addGestureRecognizer(tap)
                
                
                return userCell
            case 1:
                let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
                switch indexPath.item {
                    case 0:
                        profileCell.configure(with: "My orders", "Already have \(presenter.countOrders) orders")
                    case 1:
                        profileCell.configure(with: "My listings for sale", "\(presenter.countSaleList) Items")
                    case 2:
                        profileCell.configure(with: "Shipping addresses", "\(presenter.countAddresses) Addresses")
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 24, bottom: 24, trailing: 24)
        
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
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
            case 0:
                print(0)
            case 1:
                switch indexPath.item {
                    case 0:
                        presenter.showMyOrders()
                    case 1:
                        presenter.showMySales()
                    case 2:
                        presenter.showMyAddresses()
                    case 3:
                        presenter.showMySettings()
                    default:
                        print(indexPath.row)
                }
            default:
                print(indexPath)
        }
    }
    
    @objc private func tapOnImage(_ sender: UITapGestureRecognizer) {
        presentPhotoInputActionsheet()
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Change profile image", message: "What would you like to attach a photo from?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            let indexPath = IndexPath(row: 0, section: 0)
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
