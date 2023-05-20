//
//  LocationPickerViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 01.05.2023.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let map: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    private var coordinates: CLLocationCoordinate2D?
    public var isPiackable = true
    public var completion: (CLLocationCoordinate2D) -> () = {_ in }
    
    init(coordinates: CLLocationCoordinate2D? = nil) {
        self.coordinates = coordinates
        self.isPiackable = false
        super.init(nibName: nil, bundle: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .systemBackground
        view.addSubview(map)
        if isPiackable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonPated))
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            map.addGestureRecognizer(gesture)
            map.isUserInteractionEnabled = true
        } else {
            guard let coordinates = coordinates else {
                return
            }
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
    }
    
    @objc private func sendButtonPated() {
        guard let coordinates = coordinates else {
            showAlert()
            return
        }
        navigationController?.popViewController(animated: true)
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
    
    func showAlert() {
        let alertController = UIAlertController(title: "Where?", message: "Please choose location that you want to send", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }

}
