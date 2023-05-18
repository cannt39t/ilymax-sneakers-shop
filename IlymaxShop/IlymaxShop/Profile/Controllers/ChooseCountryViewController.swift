//
//  ChooseCountryViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.05.2023.
//

import UIKit

class ChooseCountryViewController: UIViewController {
    
    let tableView = UITableView()
    var completion: (String) -> () = { _ in }
    var countriesData = [(name: String, flag: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Choose country"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        for code in NSLocale.isoCountryCodes  {
            let flag = String.emojiFlag(for: code)
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            if let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) {
                countriesData.append((name: name, flag: flag!))
            } else {
                print("Country not found for code: \(code)")
            }
        }
        
        tableView.reloadData()
    }
    
    @objc func backButtonTaped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}


extension ChooseCountryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = countriesData[indexPath.row]
        cell.textLabel?.text = "\(country.flag) \(country.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = countriesData[indexPath.row]
        completion(country.name)
        navigationController?.popViewController(animated: true)
    }
}
