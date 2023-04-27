//
//  CatalogViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit
import JGProgressHUD

class CatalogViewController: UIViewController, UICollectionViewDelegate {
    
    public var presenter: CatalogPresenter!
    
    public var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    private let hud = JGProgressHUD()
    
    public var promotions: [Promotion] = []
    public var popular: [Shoes] = []
    public var categories: [IlymaxCategory] = []
    
    private var cur = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        showLoader()
        showCollectionView()
        presenter.fetchData()
    }
    
    
    public func showLoader() {
        hud.show(in: self.view, animated: true)
    }
    
    public func hideLoader() {
        hud.dismiss(animated: true)
    }
    
    
    public func showCollectionView() {
        setupSearchBar()
        setupCollectionView()
        setupTimer()
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "What are u looking for?"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNext() {
        if cur < promotions.count - 1 {
            cur += 1
        } else {
            cur = 0
        }
        let offset = collectionView.contentOffset
        collectionView.scrollToItem(at: IndexPath(item: cur, section: 0), at: .right, animated: true)
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(offset, animated: true)
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, enviroment: enviroment)
        })
        return layout
    }
    
    private func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
            case 0: return setupFirstSection()
            case 1: return setupSecondSection()
            case 2: return setupThirdSection()
            default: return setupFirstSection()
        }
    }
    
    
    private func setupFirstSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(256))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        //        section.visibleItemsInvalidationHandler = {
        //
        //        }
        return section
    }
    
    private func setupSecondSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalWidth(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        //supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func setupThirdSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 10)
        
        //layout
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize, repeatingSubitem: item, count: 1
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        //supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        // return
        return section
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.indertifier)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.indertifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.indertifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "HeaderView", withReuseIdentifier: "HeaderView")
        
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                print(promotions[indexPath.item])
            case 1:
                presenter.pushShoeView(shoe: popular[indexPath.item])
                print(popular[indexPath.item])
            case 2:
            presenter.pushListShoes(popular, categories[indexPath.item].name)
                print(categories[indexPath.item])
            default:
                print(indexPath)
        }
    }
    
}

extension CatalogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return promotions.count
            case 1:
                return popular.count
            case 2:
                return categories.count
            default:
                return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                let promotionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.indertifier, for: indexPath) as! PromotionCell
                promotionCell.setPromotion(promotion: promotions[indexPath.item])
                return promotionCell
            case 1:
                let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCell.indertifier, for: indexPath) as! PopularCell
                popularCell.configure(with: popular[indexPath.item])
                return popularCell
            case 2:
                let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.indertifier, for: indexPath) as! CategoryCell
                categoryCell.setCategory(category: categories[indexPath.item])
                return categoryCell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
                return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            case 1:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Most popular")
                view.didTapOnHeader = {} // вызвать презентер
                return view
            default:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Browse by category")
                return view
        }
    }
}

extension CatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchStr = searchBar.text ?? ""
        if searchStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alertController = UIAlertController(title: "Search error", message: "The string is empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            showLoader()
            presenter.pushSearchShoeList(searchStr: searchStr)
        }
    }

}
