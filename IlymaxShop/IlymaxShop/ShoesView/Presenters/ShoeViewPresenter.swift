//
//  ShoeViewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

class ShoeViewPresenter {
    weak var view: ShoeViewController?
    private let shoeViewService = ShoeViewService()
    var product: Shoes?
    
    func loadImage() {
        guard let product = product else { return }
        
        shoeViewService.getImage(for: product) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.updateImage(with: image)
            }
        }
    }
}
