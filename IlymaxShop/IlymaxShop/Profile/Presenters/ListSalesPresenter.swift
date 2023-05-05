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
    
    public var back: () -> () = {}
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
}
