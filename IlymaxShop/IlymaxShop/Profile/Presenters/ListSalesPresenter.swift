//
//  ListSalesPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation


class ListSalesPresenter {
    
    weak var view: ListSalesController?
    private let listSalesService = ListSalesService()
    public var currentUser: IlymaxUser
    public var listOfSales: [Shoes] = []
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
    func getSaleList() {
        listSalesService.getSaleList { [unowned self] result in
            switch result {
                case .success(let shoes):
                    listOfSales = shoes
                    view?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}
