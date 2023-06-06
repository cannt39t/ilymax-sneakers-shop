//
//  CatalogPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import Foundation
import UIKit

class CatalogPresenter {
    
    weak var view: CatalogViewController?
    private let catalogService = CatalogService()
    public var pushShoe: (Shoes) -> Void = {_ in }
    public var pushListShoes: ([Shoes], String, String) -> Void = {_, _, _ in }
    public var pushList: ([Shoes]) -> () = { _ in }
    
    public func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        loadPromotions(group: group)
        
        group.enter()
        loadPopular(group: group)
        
        group.enter()
        loadCategories(group: group)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadData()
            self?.view?.hideLoader()
            self?.view?.collectionView.refreshControl?.endRefreshing()
        }
    }

    private func loadPromotions(group: DispatchGroup) {
        catalogService.getAllPromotions { [weak self] promotions in
            DispatchQueue.main.async {
                self?.view?.promotions = promotions
                group.leave()
            }
        }
    }

    private func loadPopular(group: DispatchGroup) {
        catalogService.getPopularShoes { [weak self] shoes in
            DispatchQueue.main.async {
                self?.view?.popular = shoes
                group.leave()
            }
        }
    }

    private func loadCategories(group: DispatchGroup) {
        catalogService.getAllCategories { [weak self] categories in
            DispatchQueue.main.async {
                self?.view?.categories = categories
                group.leave()
            }
        }
    }
    
    public func getShoesWithIds(ids: [String]) {
        catalogService.getShoesWithIds(with: ids) { [weak self] result in
            switch result {
                case .failure(_):
                    self?.pushListShoes([], "None", "None")
                case .success(let shoes):
                    if shoes.count == 1 {
                        self?.pushShoe(shoes[0])
                    } else {
                        self?.pushListShoes(shoes, "None", "None")
                    }
            }
        }
    }
    
    func pushShoeView(shoe: Shoes) {
        pushShoe(shoe)
    }
    
    func pushShoeList(category: String) {
        catalogService.getCategoryShoes(categoryStr: category) { [weak self] shoes in
            DispatchQueue.main.async {
                self?.view?.hideLoader()
                self?.pushListShoes(shoes, category, "None")
            }
        }
    }
    
    func pushSearchShoeList(searchStr: String) {
        catalogService.getAllFilterShoes(searchStr: searchStr, selectedGender: "NONE", selectedColor: "None", selectedBrand: "None", selectedCondition: "None", selectedCategory: "None") { [weak self] shoes, error  in
            DispatchQueue.main.async {
                self?.view?.hideLoader()
                self?.pushListShoes(shoes ?? [], searchStr, searchStr)
            }
        }
    }
}
