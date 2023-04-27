//
//  PublicShoesSizeViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import UIKit

class PublicShoesSizeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var presenter: PublicShoesPresenter!
    
    private let tableView = UITableView()
    private var numberOfRows = 1
    
    private let addButton =  UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        if !presenter.product.data.isEmpty {
            numberOfRows = presenter.product.data.count
            tableView.reloadData()
        }
    }


    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Adding"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(moveBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(moveForward))

        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 30
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)), for: .normal)
        addButton.tintColor = .black
        addButton.addTarget(self, action: #selector(addNewCell), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(tableView)
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        tableView.register(SizeCell.self, forCellReuseIdentifier: "sizeCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func addNewCell() {
        numberOfRows += 1
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    @objc private func moveBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func moveForward() {
        var cellInfo: [String] = []
        presenter.product.data = []
        for cell in tableView.visibleCells {
            if let sizeCell = cell as? SizeCell {
                let buttonTitle = sizeCell.sizeButton.currentTitle ?? ""
                let textFieldValue = sizeCell.countTextField.text ?? ""
                let price = sizeCell.priceTextField.text ?? ""
                if(buttonTitle != "Select Size" && textFieldValue != "" && price != ""){
                    let shoeDetail: ShoesDetail = ShoesDetail(size: buttonTitle, price: Float(price) ?? 1, quantity: Int(textFieldValue) ?? 1)
                    presenter.product.data.append(shoeDetail)
                }
                let info = "\(buttonTitle): \(textFieldValue): \(price)"
                cellInfo.append(info)
            }
        }
        
        if( presenter.product.data.count >= 1){
            let imageAddVC = PublicShoesImageViewController()
            imageAddVC.presenter = presenter
            self.navigationController?.pushViewController(imageAddVC, animated: true)
        }else {
            let alertController = UIAlertController(title: "The next step is not available", message: "Please add at least 1 size", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath) as! SizeCell
        if (presenter.product.data.count >= numberOfRows){
            let data = presenter.product.data[indexPath.row]
            cell.sizeButton.setTitle(data.size, for: .normal)
            cell.countTextField.text = "\(data.quantity)"
            cell.priceTextField.text = "\(data.price)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if numberOfRows != 1{
            if editingStyle == .delete {
                numberOfRows -= 1
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if (presenter.product.data.count > indexPath.row){
                    presenter.product.data.remove(at: indexPath.row)
                }
                tableView.endUpdates()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

