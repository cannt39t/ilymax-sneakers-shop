//
//  ReviewViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 24.04.2023.
//

import UIKit
import JGProgressHUD

class ReviewViewController: UIViewController {
    
    var presenter: ReviewPresenter!
    private let addButton =  UIButton()
    private let hud = JGProgressHUD()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
        presenter.loadUsers()
    }
   
    func showLoader() {
        hud.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        hud.dismiss(animated: true)
    }
   
    func setupUI() {
        navigationItem.title = "Reviews"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        tableView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        
        addButton.backgroundColor = .label
        addButton.layer.cornerRadius = 30
        addButton.layer.shadowColor = UIColor.systemBackground.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal), for: .normal)
        addButton.tintColor = .systemBackground
        addButton.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        for review in presenter.reviews {
            if review.authorId == presenter.authorID {
                addButton.isHidden = true
                break
            }
        }
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func hideButton() {
        addButton.isHidden = true
    }
    
    @objc private func addReview() {
        hideButton()
        presenter.pushAdding()
    }
    
    @objc private func backButtonTapped() {
        presenter.popAdd()
    }
    
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else {
            fatalError("Unable to dequeue ReviewTableViewCell")
        }
        let review = presenter.reviews[indexPath.row]
        cell.configure(with: review, name: presenter.authors[indexPath.row], imageURL: presenter.pictureURL[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
