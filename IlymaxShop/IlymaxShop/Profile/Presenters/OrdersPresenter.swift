//
//  OrdersPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation

class OrdersPresenter {
    
    weak var view: OrdersCollectionViewController?
    private let ordersService = OrdersService()
    public var currentUser: IlymaxUser
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
}
