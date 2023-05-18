//
//  ReviewAddingViewController.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 24.04.2023.
//

import UIKit

class ReviewAddingViewController: UIViewController, UITextViewDelegate {
    var presenter: ReviewAddingPresenter!

    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let starsStackView = UIStackView()
    private let doneButton = UIButton()
    private var rating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        starConfig()
    }
    
    private func setupUI() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.title = "Add Your Review"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        
        view.backgroundColor = .systemGroupedBackground
        
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        starsStackView.axis = .horizontal
        starsStackView.spacing = 4
        starsStackView.alignment = .leading
        starsStackView.distribution = .fillEqually
        
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBackground, for: .normal)
        doneButton.backgroundColor = .label
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.delegate = self
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.masksToBounds = true

        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(doneButton)
        view.addSubview(starsStackView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: starsStackView.topAnchor, constant: -16),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 48),
            
            starsStackView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            starsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            starsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func starConfig(){

        for subview in starsStackView.arrangedSubviews {
            starsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for i in 0..<5 {
            let starImageView = UIImageView(image: i < rating ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
            starImageView.contentMode = .center
            starImageView.tintColor = UIColor.systemYellow
            starsStackView.addArrangedSubview(starImageView)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starTapped(_:)))
            starImageView.isUserInteractionEnabled = true
            starImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc func starTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedStar = sender.view as? UIImageView else { return }
        
        guard let starIndex = starsStackView.arrangedSubviews.firstIndex(of: tappedStar) else { return }
        
        rating = starIndex + 1
        starConfig()
    }

    @objc private func didTapDoneButton() {
        if rating != 0 && descriptionTextView.text != "" {
            presenter.addReview(review: IlymaxReview(text: descriptionTextView.text, rate: rating, authorId: presenter.authorID, shoesId: presenter.shoeID, date: Date()))
        } else {
            let alertController = UIAlertController(title: "You can't leave a review", message: "Please leave a rating and description", preferredStyle: .alert)
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
    
    @objc private func backButtonTapped() {
        presenter.popAdd()
    }

}
