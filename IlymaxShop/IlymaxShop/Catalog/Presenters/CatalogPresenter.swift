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
    
    public func loadPromotions() {
        catalogService.getAllPromotions { [weak self] promotions in
            self?.view?.promotions = promotions
            self?.view?.collectionView.reloadData()
        }
    }
    
    public func loadPopular() {
        catalogService.getPopularShoes { [weak self] shoes in
            self?.view?.popular = shoes
            self?.view?.collectionView.reloadData()
        }
    }
    
    public func loadCategories() {
        catalogService.getAllCategories { [weak self] categories in
            self?.view?.categories = categories
            self?.view?.collectionView.reloadData()
        }
    }
    
}
