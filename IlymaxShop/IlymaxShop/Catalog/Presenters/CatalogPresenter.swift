//
//  CatalogPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import Foundation

class CatalogPresenter {
    
    weak var view: CatalogViewController?
    private let catalogService = CatalogService()
    
    public func loadPromotions() {
        catalogService.getAllPromotions { promotions in
            catalogService.getAllCategories { categories in
                view?.c
            }
        }
    }
    
}
