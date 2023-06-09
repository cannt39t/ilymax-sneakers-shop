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
    
    public var promotions: [IlymaxPromotion] = []
    public var popular: [Shoes] = []
    public var categories: [IlymaxCategory] = []
    
    private var cur = 0
    private var timer: Timer?
    
    private var ilymaxLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 150)))
        label.text = "ILYMAX"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.addCharacterSpacing(kernValue: 35)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        
        navigationController?.navigationBar.topItem?.titleView = ilymaxLabel
        
        showLoader()
        showCollectionView()
//        setupRefreshController()
        presenter.fetchData()
    }
    
    public func showLoader() {
        hud.show(in: self.view, animated: true)
    }
    
    public func hideLoader() {
        hud.dismiss(animated: true)
    }
    
    func setupRefreshController() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter.fetchData()
    }
    
    public func showCollectionView() {
        setupCollectionView()
        setupTimer()
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "What are u looking for?"
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(256))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
        return section
    }
    
    private func setupThirdSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        //layout
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(72))
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize, repeatingSubitem: item, count: 1
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
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
        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.indertifier)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.indertifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.indertifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "HeaderView", withReuseIdentifier: "HeaderView")
        
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
            case 0:
                presenter.getShoesWithIds(ids: promotions[indexPath.item].shoesIds)
            case 1:
                presenter.pushShoeView(shoe: popular[indexPath.item])
            case 2:
                showLoader()
                presenter.pushShoeList(category: categories[indexPath.item].name)
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
                view.setTitle(with: "Most popular", hide: false)
                view.didTapOnHeader = {} // вызвать презентер
                return view
            default:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                view.setTitle(with: "Browse by category", hide: true)
                return view
        }
    }
}

extension CatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchStr = searchBar.text ?? ""
        if searchStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
        } else {
            showLoader()
            presenter.pushSearchShoeList(searchStr: searchStr)
        }
    }

}
