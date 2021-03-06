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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var zoominButton: UIButton!
    @IBOutlet weak var zoomoutButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
        {
        didSet {
            mapView.delegate = self
            mapView.mapType = .Standard
            mapView.showsUserLocation = true
        }
    }
    let locationManager = CLLocationManager()
    
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
    
    func setupMapView() {
        mapView.frame = CGRectMake(0,0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        segmentedControl.frame = CGRectMake(UIScreen.mainScreen().bounds.width/8, UIScreen.mainScreen().bounds.height * 1/15, UIScreen.mainScreen().bounds.width * 8/10, 35)
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.backgroundColor = UIColor(red: 51/255, green: 92/255, blue: 122/255, alpha: 1.0)
        segmentedControl.layer.borderColor = UIColor.whiteColor().CGColor
        segmentedControl.layer.borderWidth = 2
        
        segmentedControl.setTitleTextAttributes(NSDictionary(objects: [UIFont(name: "Futura", size: 14)!], forKeys: [NSFontAttributeName]) as [NSObject: AnyObject], forState: UIControlState.Normal)
        
        
        zoominButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 50, UIScreen.mainScreen().bounds.height/5, 30, 30)
        zoomoutButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 50, UIScreen.mainScreen().bounds.height/5 + 33, 30, 30)
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
        
        setupMapView()
        let center = handleExistingMusic()
        //addRadiusCircle(CLLocation(latitude: center.latitude, longitude: center.longitude)) don't need this right now
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
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: 10000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
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
                    self.mapView.addAnnotations(objects)
                    for object in objects {
                        
                        totalLat = totalLat + object["location"].latitude
                        totalLong = totalLong + object["location"].longitude
                        //self.mapView.showAnnotations(objects, animated: true)
                    }
                }
                else
                {
                    print("failed to enter")
                }
        
        return CLLocationCoordinate2D(latitude: totalLat/numObjects, longitude: totalLong/numObjects)
    }
    
    //this function makes the blue user location into a red pin
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("PFObject")
        if annotation.title! == "Current Location" {
            
        }
        else {
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PFObject")
                view?.canShowCallout = true
//              view.pinTintColor = UIColor.blueColor()
            }
            else {
                view?.annotation = annotation
            }
            view?.leftCalloutAccessoryView = nil
            view?.rightCalloutAccessoryView = nil
            if let pf = annotation as? PFObject {
                if pf.image != nil {
                    view?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
                    view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
                }
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"
        {
            if let pf = (sender as? MKAnnotationView)?.annotation as? PFObject
            {
                let vc = segue.destinationViewController as! SongDetailViewController
                vc.selectedArtist = pf["artist"] as! String
                vc.selectedSongName = pf["title"] as! String
                vc.selectedAlbum = pf["album"] as! String
                vc.selectedSharedBy = (pf["username"] as! String)
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
