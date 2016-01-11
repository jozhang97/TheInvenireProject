//
//  NewMapViewController.swift
//  Invenire
//
//  Created by Jeffrey Zhang on 1/8/16.
//  Copyright © 2016 Jeffrey Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var zoomFactor:CLLocationDistance = 50000
    
    @IBAction func zoomIn(sender: AnyObject) {
        zoomFactor -= 5000
        //let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
                mapView.centerCoordinate, zoomFactor, zoomFactor)
            mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func zoomOut(sender: AnyObject) {
        zoomFactor += 5000
        //let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(
            mapView.centerCoordinate, zoomFactor, zoomFactor)
        mapView.setRegion(region, animated: true)
    }
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    {
        didSet {
            mapView.delegate = self
            mapView.mapType = .Standard
            mapView.showsUserLocation = true
        }
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentChanged(sender: AnyObject)
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            mapView.mapType = .Standard
        }
        else if segmentedControl.selectedSegmentIndex == 1
        {
            mapView.mapType = .Hybrid
        }
        else if segmentedControl.selectedSegmentIndex == 2
        {
            mapView.mapType = .Satellite
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var center = mapView.centerCoordinate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //clearAnnotations()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
        
        /* OLD WAY of showing area around user
        var location = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        */
        
        /* Another way
        var currentLocation = CLLocation()
        if CLLocationManager.locationServicesEnabled()
        {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location!
        }
        var userLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation, zoomFactor, zoomFactor)
        mapView.setRegion(region, animated: true)
        */
        
        let center = handleExistingMusic()
        addRadiusCircle(CLLocation(latitude: center.latitude, longitude: center.longitude))
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(1, 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: 10000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    /*
    func clearAnnotations()
    {
        if mapView?.annotations != nil
        {
            mapView.removeAnnotations(mapView.annotations as [MKAnnotation])
        }
    }
    */
    
    func handleExistingMusic()->CLLocationCoordinate2D {
        let query = PFQuery(className:"Posts")
        var totalLat:Double = 0
        var totalLong:Double = 0
        var numObjects:Double = 1
        
        query.whereKey("location", nearGeoPoint: findLocation(), withinMiles: 100)
        let objects = try? query.findObjects()
        
                // The find succeeded.
                numObjects = Double(objects!.count)
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.mapView.addAnnotations(objects)
                        
                        totalLat = totalLat + object["location"].latitude
                        totalLong = totalLong + object["location"].longitude
                        //self.mapView.showAnnotations(objects, animated: true)
                    }
                }
        
        return CLLocationCoordinate2D(latitude: totalLat/numObjects, longitude: totalLong/numObjects)
    }
    
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("PFObject")
        
        if view == nil
        {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PFObject")
            view?.canShowCallout = true
//            view.pinTintColor = UIColor.blueColor()
        }
        else
        {
            view?.annotation = annotation
        }
    
        
        view?.leftCalloutAccessoryView = nil
        view?.rightCalloutAccessoryView = nil
        if let pf = annotation as? PFObject
        {
            if pf.image != nil
            {
                view?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
                view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
            }
        }
        
        return view
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        if let pf = view.annotation as? PFObject
        {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView
            {
                if let image = pf.image
                {
                    thumbnailImageView.image = image
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("showDetails", sender: view)
    }
    
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"
        {
            if let pf = (sender as? MKAnnotationView)?.annotation as? PFObject
            {
                let vc = segue.destinationViewController as! SongDetailViewController
                vc.selectedArtist = pf["artist"] as! String
                vc.selectedSongName = pf["title"] as! String
                vc.selectedAlbum = pf["album"] as! String
                vc.selectedSharedBy = "Shared by " + (pf["username"] as! String)
                let distance: Double = findDistance(pf["location"] as! PFGeoPoint)
                vc.selectedDistance = "distance: " + String(distance) + "miles away"
                let likes = pf["numLikes"] as! Int
                vc.selectedLikes = "Liked by " + String(likes)
                vc.selectedArtwork = pf.image
                vc.check = 2
            }
        }
    }
    
    func findLocation() -> PFGeoPoint {

        let currLocation = locationManager.location
        let currLocationGeoPoint = PFGeoPoint(location: currLocation)
        return currLocationGeoPoint
    }
    
    func findDistance(musicLocation :PFGeoPoint) -> Double {
        let currLocation = findLocation()
        print("locations are")
        print(currLocation)
        print(musicLocation)
        let distance = round(100*musicLocation.distanceInMilesTo(currLocation))/100
        print(distance)
        return distance
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
