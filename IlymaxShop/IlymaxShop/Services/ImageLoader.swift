//
//  ImageLoader.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 23.03.2023.
//

import UIKit

class ImageLoader {
    private var dataTask: URLSessionDataTask?
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        dataTask?.cancel()
        let urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData
        )
        dataTask = URLSession.shared
            .dataTask(with: urlRequest) { data, _, _ in
                guard let data = data else {
                    print("could not load image")
                    completion(nil)
                    return
                }

                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        dataTask?.resume()
    }
}

