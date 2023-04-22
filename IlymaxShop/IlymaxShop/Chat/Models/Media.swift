//
//  Media.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.04.2023.
//

import UIKit
import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
