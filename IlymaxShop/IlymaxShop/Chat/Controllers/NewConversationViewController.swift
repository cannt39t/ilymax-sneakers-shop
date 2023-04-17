//
//  NewConversationViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()
    
    var results: [IlymaxUser] = []
    
    public let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    let spinner = JGProgressHUD(style: .dark)
    
    public let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    var presenter: NewConversationPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(disMissSelf))
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func disMissSelf() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
             return
        }
        
        print(text)
        
        spinner.show(in: view)
        presenter.searchUsers(query: text)
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation (push chatViewController???)
    }
}
