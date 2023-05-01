//
//  LocationPickerViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.05.2023.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    private var coordinates: CLLocationCoordinate2D?
    
    public var completion: (CLLocationCoordinate2D) -> () = {_ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Pick Location"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        view.addSubview(map)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonPated))
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap ))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        map.addGestureRecognizer(gesture)
        map.isUserInteractionEnabled = true
    }
    
    @objc private func sendButtonPated() {
        guard let coordinates = coordinates else {
            return
        }
        completion(coordinates)
    }
    
    @objc private func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        
        for annotion in map.annotations {
            map.removeAnnotation(annotion)
        }
        // drop pin on this location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    
    override func viewDidLayoutSubviews() {
        map.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            map.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
