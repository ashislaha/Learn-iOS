//
//  MapViewController.swift
//  Explore Direction
//
//  Created by Ashis Laha on 09/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import GoogleMaps

let defaultZoomLabel : Float = 19.0

class MapViewController: UIViewController , UIGestureRecognizerDelegate {
    
    let polylineStokeWidth : CGFloat = 5.0
    
    private var mapView : GMSMapView!
    private var userLocationMarker : GMSMarker!
    private var polyline : GMSPolyline!
    private var dropLocationMarker : GMSMarker!
    
    private var paths : [CLLocationCoordinate2D] = []
    private var destination : CLLocationCoordinate2D?
    
    //MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate  as? AppDelegate else { return }
        appDelegate.locationManager.delegate = self
        appDelegate.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        guard let appDelegate = UIApplication.shared.delegate  as? AppDelegate else { return }
//        appDelegate.locationManager.stopUpdatingLocation()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerNotification()
        reachabilityCheck()
    }
    
    private func reachabilityCheck() {
        if !ReachabilityHelper.isInternetAvailable() {
            let alert = UIAlertController(title: "No Internet", message: "Please connect to Internet", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (button) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            self?.reachabilityCheck()
        }
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        polyline?.map = nil
        dropLocationMarker?.map = nil
        paths = []
        destination = nil
    }
    
    @IBAction func viewOpen(_ sender: UIBarButtonItem) {
        // validation for intro sceen
        if !isOlaLensIntoShownBefore() {
            let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
            guard let introScreenVC = storyboard.instantiateViewController(withIdentifier: "OlaLensIntroPageViewController") as? OlaLensIntroPageViewController else { return }
            introScreenVC.delegate = self
            present(introScreenVC, animated: true, completion: nil)
            
        } else {
            openARView()
        }
    }
    
    private func isOlaLensIntoShownBefore() -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.value(forKey: Constants.showIntro) as? Bool ?? false
    }
    
    private func openARView() {
        guard !paths.isEmpty else { return }
        
        if let arVC = UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ARViewController") as? ARViewController {
            let model = OlaLensModel()
            model.carLocation = destination
            model.sectionCoordinates = paths
            model.carRegisterNumber = "KA00421L"
            model.carNumber = "0045"
            arVC.model = model
            self.present(arVC, animated: true, completion: nil)
        }
    }
    
    private func handleGoogleMap() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if let userLocation = appDelegate.locationManager.location?.coordinate {
            self.googleMapSetUp(location: userLocation)
        }
        if self.mapView != nil {
            self.mapView.delegate = self
        }
        self.title = "Tap On Map"
    }
    
    private func googleMapSetUp(location : CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: defaultZoomLabel)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isUserInteractionEnabled = true
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(mapView)
    }
    
    private func createMarker(location : CLLocationCoordinate2D, mapView : GMSMapView, markerTitle : String, snippet : String, image : UIImage? = nil, markerName : String? = nil) -> GMSMarker {
        let marker = GMSMarker(position: location)
        marker.title =  markerTitle
        marker.snippet = snippet
        if let image = image {
            marker.icon = image
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        }
        if let markerName = markerName {
            marker.userData = markerName
        }
        marker.map = mapView
        return marker
    }
    
    private func removeMarker(marker : GMSMarker) {
        marker.map = nil
    }
    
    private func drawPath(map : GMSMapView, pathArray : [(Double, Double)]) {
        let path = GMSMutablePath()
        for each in pathArray {
            path.add(CLLocationCoordinate2D(latitude: each.0, longitude: each.1))
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.blue
        polyline.strokeWidth = polylineStokeWidth
        polyline.geodesic = true
        polyline.map = map
    }
}

extension MapViewController : ShowOlaLensIntroDelegate {
    
    func allowCameraClicked() {
        openARView()
    }
}


extension MapViewController : CLLocationManagerDelegate {
    
    
    private func sameLocation(location1 : CLLocationCoordinate2D, location2 : CLLocationCoordinate2D) -> Bool  {
        return location1.latitude == location2.latitude && location1.longitude == location2.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let location = locations.last else { return }
        
        if let mapView = mapView {
            if let userLocationMarker = self.userLocationMarker {
                removeMarker(marker: userLocationMarker)
            }
            userLocationMarker = GMSMarker(position: location.coordinate)
            userLocationMarker.title = "User Location"
            userLocationMarker.snippet = ""
            if let image = UIImage(named: "blue-dot") {
                userLocationMarker.icon = image
                userLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
            }
            userLocationMarker.map = mapView
            
            // one time execution
            if appDelegate.one_time_execution == false {
                appDelegate.one_time_execution = true
                let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: defaultZoomLabel, bearing: 0, viewingAngle: 0)
                mapView.animate(to: cameraPosition)
            }
            
            if let carLocation = destination {
                let distance = location.distance(from: CLLocation(latitude: carLocation.latitude, longitude: carLocation.longitude))
                appDelegate.distance = distance
            }
        } else {
            handleGoogleMap()
        }
    }
    
    
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
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
}

extension MapViewController : GMSMapViewDelegate {
    
    //MARK:- Create marker on long press
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        self.dropLocationMarker?.map = nil
        self.dropLocationMarker =  createMarker(location: coordinate, mapView: self.mapView, markerTitle: "Destination", snippet: "", image: UIImage(named: "drop-pin"))
        
        reachabilityCheck()
        guard let appDelegate = UIApplication.shared.delegate  as? AppDelegate else { return }
        
        if let userLocation = appDelegate.locationManager.location?.coordinate {
            if ReachabilityHelper.isInternetAvailable() {
                fetchRoute(source: userLocation, destination: coordinate, completionHandler: { [weak self] (polyline) in
                    
                    if let polyline = polyline as? GMSPolyline {
                        
                        // Add user location
                        let path = GMSMutablePath()
                        path.add(userLocation)
                        
                        // add rest of the  co-ordinates
                        if let polyLinePath = polyline.path, polyLinePath.count() > 0 {
                            for i in 0..<polyLinePath.count() {
                                path.add(polyLinePath.coordinate(at: i))
                            }
                        }
                        
                        let updatedPolyline = GMSPolyline(path: path)
                        updatedPolyline.strokeColor = UIColor.blue
                        updatedPolyline.strokeWidth = self?.polylineStokeWidth ?? 5.0
                        
                        self?.polyline?.map = nil
                        self?.polyline = updatedPolyline
                        self?.polyline?.map = self?.mapView
                        
                        // update path and destination
                        self?.destination = coordinate
                        
                        if let path = updatedPolyline.path {
                            var polylinePath : [CLLocationCoordinate2D] = []
                            for i in 0..<path.count()-1 {
                                polylinePath.append(path.coordinate(at: i))
                            }
                            self?.paths = []
                            self?.paths = polylinePath
                        }
                    }
                })
            }
        }
    }
    
    private func fetchRoute(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D , completionHandler : ((Any) -> ())? ) {
        let origin = String(format: "%f,%f", source.latitude,source.longitude)
        let destination = String(format: "%f,%f", destination.latitude,destination.longitude)
        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
        let directionsUrlString = String(format: "%@&origin=%@&destination=%@&mode=walking",directionsAPI,origin,destination ) // walking , driving
        
        if let url = URL(string: directionsUrlString) {
            
            let fetchDirection = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if error == nil && data != nil {
                        var polyline : GMSPolyline?
                        if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments ) as? [String : Any] {
                            if let routesArray = dictionary?["routes"] as? [Any], !routesArray.isEmpty {
                                if let routeDict = routesArray.first as? [String : Any] , !routeDict.isEmpty {
                                    if let routeOverviewPolyline = routeDict["overview_polyline"] as? [String : Any] , !routeOverviewPolyline.isEmpty {
                                        if let points = routeOverviewPolyline["points"] as? String {
                                            if let path = GMSPath(fromEncodedPath: points) {
                                                polyline = GMSPolyline(path: path)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let polyline = polyline { completionHandler?(polyline) }
                    }
                }
            })
            fetchDirection.resume()
        }
    }
    
}


