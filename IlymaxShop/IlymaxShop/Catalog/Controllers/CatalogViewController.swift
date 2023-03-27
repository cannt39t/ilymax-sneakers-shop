//
//  CatalogViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class CatalogViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    
    var cur = 0
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSearchBar()
        setupCollectionView()
        setupTimer()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Whar are u looking for?"
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
        if cur < 4 {
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func setupThirdSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        //layout
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize, repeatingSubitem: item, count: 1
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        //supplementary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HeaderView", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        // return
        return section
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "HeaderView", withReuseIdentifier: "HeaderView")
        
        collectionView.dataSource = self
    }
    
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 2 ? 15 : 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            case 1:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                view.title = "Most popular"
                view.buttonTitle = ">"
                view.didTapOnHeader = {} // вызвать презентер
                return view
            default:
                guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "HeaderView", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                view.title = "Browse by category"
                return view
        }
    }
}

extension CatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
}
