//
//  VideoViewerViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 27.04.2023.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewerViewController: AVPlayerViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Video"
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setup()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setup() {

    }
    
}
