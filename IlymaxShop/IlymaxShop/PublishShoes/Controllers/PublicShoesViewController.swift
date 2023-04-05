//
//  PublicShoesViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class PublicShoesViewController: UIViewController, UITextViewDelegate {
    var presenter: PublicShoesPresenter!

    let genders = ["MAN", "WOMAN", "UNISEX"]
    var genderActions = [UIAction]()
    let companies = ["ILYMAX", "Nike", "Adidas", "Vans", "Timberland", "Puma", "Crocs", "Reebok", "Converse", "Lacoste", "Jordan", "Barbour", "TODS", "Brioni", "Gucci", "Diesel", "New Balance", "Ocai", "Diadora", "DrMartens", "Asics", "Boss", "Salomon", "UGG"]
    var companyActions = [UIAction]()
    let colors = [ "Black", "Blue", "Brown", "Gold", "Green", "Grey", "Multi", "Navy", "Neutral", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow"]
    var colorActions = [UIAction]()
    var categoryActions = [UIAction]()
    let conditions = ["NEW", "PiU"]
    var conditionActions = [UIAction]()

    private let nameLabel = UILabel()
    private let nameTextView = UITextView()
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let genderLabel = UILabel()
    private let genderButton = UIButton()

    private let companyLabel = UILabel()
    private let companyButton = UIButton()

    private let colorLabel = UILabel()
    private let colorButton = UIButton()

    private let categoryLabel = UILabel()
    private let categoryButton = UIButton()

    private let conditionLabel = UILabel()
    private let conditionButton = UIButton()

    override func viewDidLoad() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Adding"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(moveForward))
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)

        nameLabel.text = "Name"
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameTextView.text = presenter.product.name
        nameTextView.delegate = self
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.isScrollEnabled = false
        nameTextView.font = UIFont.systemFont(ofSize: 16)
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.text = presenter.product.description
        descriptionTextView.delegate = self
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)

        genderLabel.text = "Gender"
        genderLabel.font = UIFont.systemFont(ofSize: 30)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if presenter.product.gender != ""{
            genderButton.setTitle("\(presenter.product.gender)", for: .normal)
        }else{
            genderButton.setTitle("Select Gender", for: .normal)
        }
        genderButton.setTitleColor(.black, for: .normal)

        for gender in genders {
            let genderAction = UIAction(title: gender) { [weak self] action in
                self?.genderButton.setTitle(gender, for: .normal)
            }
            genderActions.append(genderAction)
        }
        let genderMenu = UIMenu(title: "Select Gender", children: genderActions)
        genderButton.menu = genderMenu
        genderButton.showsMenuAsPrimaryAction = true
        
        genderButton.translatesAutoresizingMaskIntoConstraints = false

        
        companyLabel.text = "Company"
        companyLabel.font = UIFont.systemFont(ofSize: 30)
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if presenter.product.company != ""{
            companyButton.setTitle("\(presenter.product.company)", for: .normal)
        }else{
            companyButton.setTitle("Select Company", for: .normal)
        }
        companyButton.setTitleColor(.black, for: .normal)
        for company in companies {
            let companyAction = UIAction(title: company) { [weak self] action in
                self?.companyButton.setTitle(company, for: .normal)
            }
            companyActions.append(companyAction)
        }

        let companyMenu = UIMenu(title: "Select Company", children: companyActions)

        companyButton.menu = companyMenu
        companyButton.showsMenuAsPrimaryAction = true
        companyButton.translatesAutoresizingMaskIntoConstraints = false


        
        colorLabel.text = "Color"
        colorLabel.font = UIFont.systemFont(ofSize: 30)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if presenter.product.color != ""{
            colorButton.setTitle("\(presenter.product.color)", for: .normal)
        }else{
            colorButton.setTitle("Select Color", for: .normal)
        }
        colorButton.setTitleColor(.black, for: .normal)
        colorButton.layer.borderColor = UIColor.black.cgColor
        for color in colors {
            let colorAction = UIAction(title: color) {  [weak self] action in
                self?.colorButton.setTitle(color, for: .normal)
            }
            colorActions.append(colorAction)
        }

        let colorMenu = UIMenu(title: "Select Color", children: colorActions)

        colorButton.menu = colorMenu
        colorButton.showsMenuAsPrimaryAction = true
        colorButton.translatesAutoresizingMaskIntoConstraints = false

        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.systemFont(ofSize: 30)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if presenter.product.category != "" {
            categoryButton.setTitle("\(presenter.product.category)", for: .normal)
        } else {
            categoryButton.setTitle("Select Category", for: .normal)
        }

        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.layer.borderColor = UIColor.black.cgColor
        for category in presenter.categories {
            let categoryAction = UIAction(title: category) {  [weak self] action in
                self?.categoryButton.setTitle(category, for: .normal)
            }
            categoryActions.append(categoryAction)
        }

        let categoryMenu = UIMenu(title: "Select Category", children: categoryActions)

        categoryButton.menu = categoryMenu
        categoryButton.showsMenuAsPrimaryAction = true
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        conditionLabel.text = "Condition"
        conditionLabel.font = UIFont.systemFont(ofSize: 30)
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false

        if presenter.product.condition != ""{
            conditionButton.setTitle("\(presenter.product.condition)", for: .normal)
        }else{
            conditionButton.setTitle("Select Condition", for: .normal)
        }
        conditionButton.setTitleColor(.black, for: .normal)
        conditionButton.layer.borderColor = UIColor.black.cgColor
        for condition in conditions {
            let conditionAction = UIAction(title: condition) {  [weak self] action in
                self?.conditionButton.setTitle(condition, for: .normal)
            }
            conditionActions.append(conditionAction)
        }

        let conditionMenu = UIMenu(title: "Select Condition", children: conditionActions)

        conditionButton.menu = conditionMenu
        conditionButton.showsMenuAsPrimaryAction = true
        conditionButton.translatesAutoresizingMaskIntoConstraints = false

        let textStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextView, descriptionLabel, descriptionTextView])
        textStackView.axis = .vertical
        textStackView.spacing = 16
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        let secondStackView = UIStackView(arrangedSubviews: [
            genderLabel, genderButton, companyLabel, companyButton, colorLabel,  colorButton, categoryLabel, categoryButton, conditionLabel, conditionButton
        ])
        secondStackView.axis = .vertical
        secondStackView.spacing = 16
        secondStackView.alignment = .leading
        secondStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [textStackView, secondStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }


    @objc private func moveForward() {
        let gender = genderButton.title(for: .normal)
        let company = companyButton.title(for: .normal)
        let color = colorButton.title(for: .normal)
        let category = categoryButton.title(for: .normal)
        let condition = conditionButton.title(for: .normal)
        
        if nameTextView.text != "" && descriptionTextView.text != "" && gender != "Select Gender" && company != "Select Company" && color != "Select Color" && category != "Select Category" && condition != "Select Condition" {
            presenter.product.name = nameTextView.text ?? ""
            presenter.product.description = descriptionTextView.text ?? ""
            presenter.product.gender = gender ?? ""
            presenter.product.company = company ?? ""
            presenter.product.color = color ?? ""
            presenter.product.category = category ?? ""
            presenter.product.condition = condition ?? ""
            let sizeAddVC = PublicShoesSizeViewController()
            sizeAddVC.presenter = presenter
            self.navigationController?.pushViewController(sizeAddVC, animated: true)
        } else {
            let alertController = UIAlertController(title: "The next step is not available", message: "Please fill in all fields", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)

        }
    }
    
    // MARK: - Если по нажатию на "Return" нужно скрыть клавиатуру
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
