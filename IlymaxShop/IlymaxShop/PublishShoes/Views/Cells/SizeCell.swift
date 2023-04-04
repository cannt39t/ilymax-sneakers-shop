//
//  SizeCell.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 04.04.2023.
//

import UIKit

class SizeCell: UITableViewCell {
    let sizes = ["35", "35.5", "36", "36.5", "37", "37.5", "38", "38.5", "39", "39.5", "40", "40.5", "41", "41.5", "42", "42.5", "43", "43.5", "44", "44.5", "45", "45.5", "46", "46.5", "47", "47.5", "48"]
    var sizeActions = [UIAction]()
    
    let sizeButton = UIButton()
    let countTextField = UITextField()
    let priceTextField = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let sizeLabel = UILabel()
        sizeLabel.text = "Size"
        sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        sizeLabel.textColor = .gray
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sizeButton.setTitle("Select Size", for: .normal)
        sizeButton.setTitleColor(.black, for: .normal)
        
        for size in sizes {
            let sizeAction = UIAction(title: "\(size) EU") { [weak self] action in
                self?.sizeButton.setTitle("\(size) EU", for: .normal)
            }
            sizeActions.append(sizeAction)
        }
        let sizeMenu = UIMenu(title: "Select Size", children: sizeActions)
        sizeButton.menu = sizeMenu
        sizeButton.showsMenuAsPrimaryAction = true
        sizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let sizeStackView = UIStackView(arrangedSubviews: [sizeLabel, sizeButton])
        sizeStackView.alignment = .leading
        sizeStackView.axis = .vertical
        sizeStackView.spacing = 4
        sizeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let countLabel = UILabel()
        countLabel.text = "Quantity"
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        countLabel.textColor = .gray
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countTextField.placeholder = "Quantity"
        countTextField.keyboardType = .numberPad
        countTextField.borderStyle = .roundedRect
        countTextField.delegate = self
        countTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let countStackView = UIStackView(arrangedSubviews: [countLabel, countTextField])
        countStackView.alignment = .leading
        countStackView.axis = .vertical
        countStackView.spacing = 4
        countStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let priceLabel = UILabel()
        priceLabel.text = "Price $"
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = .gray
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceTextField.placeholder = "Price   "
        priceTextField.keyboardType = .numberPad
        priceTextField.borderStyle = .roundedRect
        priceTextField.delegate = self
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, priceTextField])
        priceStackView.alignment = .leading
        priceStackView.axis = .vertical
        priceStackView.spacing = 4
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let allInStack = UIStackView(arrangedSubviews: [sizeStackView, countStackView, priceStackView])
        allInStack.distribution = .equalSpacing
        allInStack.axis = .horizontal
        allInStack.spacing = 4
        allInStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(allInStack)
        
        NSLayoutConstraint.activate([
            allInStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            allInStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allInStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            allInStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getQuantity() -> Int? {
        return Int(countTextField.text ?? "")
    }

}

extension SizeCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }

        let newLength = text.count + string.count - range.length

        return newLength <= 5
    }
    
}
