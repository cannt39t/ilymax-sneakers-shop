//
//  ModalFilterViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

enum SortOption: CustomStringConvertible {
    case priceHighToLow
    case priceLowToHigh

    var description: String {
        switch self {
        case .priceHighToLow:
            return "Price High to Low"
        case .priceLowToHigh:
            return "Price Low to High"
        }
    }
}


class ModalFilterViewController: UIViewController {

    private let tableView = UITableView()
    private let submitButton = UIButton()

    private var selectedGender: String?
    private var selectedSize: Double?
    private var selectedColor: String?
    private var selectedBrand: String?
    private var selectedCondition: String?
    private var selectedSort: SortOption?

    private let genders = ["Man", "Woman", "Unisex"]
    private let sizes = [35, 35.5, 36, 36.5, 37, 37.5, 38, 38.5, 39, 39.5, 40, 40.5, 41, 41.5, 42, 42.5, 43, 43.5, 44, 44.5, 45, 45.5, 46, 46.5, 47, 47.5, 48]
    private let colors = ["Black", "Blue", "Brown", "Gold", "Green", "Grey", "Multi", "Navy", "Neutral", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow"]
    private let brands = ["ILYMAX", "Nike", "Adidas", "Vans", "Timberland",  "Puma",  "Crocs", "Reebok",  "Converse", "Lacoste",  "Jordan", "Barbour",  "TODS",   "Brioni", "Gucci", "Diesel", "NB", "Diadora", "DrMartens",  "Asics", "Boss", "Salomon", "UGG"]
    private let conditions = ["New", "Pre-owned"]

    private let sortOptions: [SortOption] = [.priceHighToLow, .priceLowToHigh]


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureViews()
        configureLayout()
    }

    private func configureViews() {
        view.addSubview(tableView)
        view.addSubview(submitButton)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()

        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .black
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    private func configureLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16)
        ])

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Обращение к презентеру, передача данных, обновление view
    @objc private func submitButtonTapped() {
        print("Selected Sort Option: \(selectedSort?.description ?? "None")")
        print("Selected Gender: \(selectedGender ?? "None")")
        if let selectedSize = selectedSize {
            print("Selected Size: " + String(selectedSize))
        } else {
            print("Selected Size: None")
        }
        print("Selected Color: \(selectedColor ?? "None")")
        print("Selected Brand: \(selectedBrand ?? "None")")
        print("Selected Condition: \(selectedCondition ?? "None")")
        dismiss(animated: true)
    }
}


extension ModalFilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sortOptions.count
        case 1:
            return genders.count
        case 2:
            return conditions.count
        case 3:
            return brands.count
        case 4:
            return sizes.count
        case 5:
            return colors.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .none

        switch indexPath.section {
        case 0:
            let sortOption = sortOptions[indexPath.row]
            cell.textLabel?.text = sortOption.description
            if sortOption == selectedSort {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        case 1:
            let gender = genders[indexPath.row]
            cell.textLabel?.text = gender
            if gender == selectedGender {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        case 2:
            let condition = conditions[indexPath.row]
            cell.textLabel?.text = condition
            if condition == selectedCondition {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        case 3:
            let brand = brands[indexPath.row]
            cell.textLabel?.text = brand
            if brand == selectedBrand {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        case 4:
            let size = sizes[indexPath.row]
            cell.textLabel?.text = "\(size) EU"
            if size == selectedSize {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        case 5:
            let color = colors[indexPath.row]
            cell.textLabel?.text = color
            if color == selectedColor {
                cell.accessoryType = .checkmark
                cell.tintColor = .black
            }
        default:
            break
        }

        return cell
    }
}


extension ModalFilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sort By"
        case 1:
            return "Gender"
        case 2:
            return "Condition"
        case 3:
            return "Brand"
        case 4:
            return "Size"
        case 5:
            return "Color"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            selectedSort = sortOptions[indexPath.row]
            tableView.reloadData()
        case 1:
            selectedGender = genders[indexPath.row]
            tableView.reloadData()
        case 2:
            selectedCondition = conditions[indexPath.row]
            tableView.reloadData()
        case 3:
            selectedBrand = brands[indexPath.row]
            tableView.reloadData()
        case 4:
            selectedSize = sizes[indexPath.row]
            tableView.reloadData()
        case 5:
            selectedColor = colors[indexPath.row]
            tableView.reloadData()
        default:
            break
        }
    }

}
