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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAnnotations()
        handleExistingMusic()
        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func clearAnnotations()
    {
        if mapView?.annotations != nil
        {
            mapView.removeAnnotations(mapView.annotations as [MKAnnotation])
        }
    }
    
    func handleExistingMusic() {
        let query = PFQuery(className:"Posts")
//      Try the next line if the images don't show up
//        let objects = try? query.findObjects()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.mapView.addAnnotations(objects)
                        self.mapView.showAnnotations(objects, animated: true)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
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
                vc.check = 0
            }
        }
    }
    
    func findLocation() -> PFGeoPoint {

        let currLocation = locationManager.location
        let currLocationGeoPoint = PFGeoPoint(location: currLocation)
        return currLocationGeoPoint
//        var currLocation: PFGeoPoint?
//        PFGeoPoint.geoPointForCurrentLocationInBackground ({
//            (point: PFGeoPoint?, error: NSError?) -> Void in
//            if error == nil {
//                print("Why didn't I test this")
//                currLocation = point!
//            }
//            else
//            {
//                print(error)
//            }
//        })
//        return currLocation
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
