//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Lalit Kumar on 29/10/18.
//  Copyright © 2018 Lalit Kumar. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locManager: CLLocationManager!
    let regionRadius: CLLocationDistance = Constants.MAP_RADIUS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        locManager = CLLocationManager()
        locManager.delegate = self
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.isZoomEnabled = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationSelected))
        tapRecognizer.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(tapRecognizer)
//        if let data = UserDefaults.standard.data(forKey: KeyConstants.LAST_LOCATION_USER_DEFAULT_KEY) as? WeatherData {
//            refreshView(withWeatherData: data)
//        }
    }
    
    @objc func locationSelected(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print(location)
        fetchWeatherData(forCoordinates: location)
    }
    
    
    func fetchWeatherData(forCoordinates coordinate: CLLocationCoordinate2D) {
        NetworkManager.getWeatherData(lat: coordinate.latitude, lon: coordinate.longitude, completion: { [weak self] data in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    //UserDefaults.standard.set(data, forKey: KeyConstants.LAST_LOCATION_USER_DEFAULT_KEY)
                    strongSelf.refreshView(withWeatherData: data)
                }
            }
        })
    }
    
    func refreshView(withWeatherData data: WeatherData) {
        let coordinate = CLLocationCoordinate2D(latitude: data.coord.lat, longitude: data.coord.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = data.name
        annotation.subtitle = "\(data.main.temp) °C"
        mapView.addAnnotation(annotation)
        //It will keep adding annotation - When every time this methoda calls - Have to remove previous annotation before adding new one
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            showAlertController(withTitle: StringConstants.LOCATION_PERMISSION_TITLE, message: StringConstants.LOCATION_PERMISSION_DETAIL_MESSAGE)
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            showAlertController(withTitle: StringConstants.LOCATION_PERMISSION_TITLE, message: StringConstants.LOCATION_PERMISSION_DETAIL_MESSAGE)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fetchWeatherData(forCoordinates: locValue)
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        pinView.canShowCallout = true
        return pinView
    }
}
