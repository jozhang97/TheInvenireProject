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

class NewMapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    {
        didSet {
            mapView.delegate = self
            mapView.mapType = .Satellite
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAnnotations()
        handleExistingMusic()
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
        let objects = try? query.findObjects()
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
                        self.mapView.addAnnotations(objects!)
                        self.mapView.showAnnotations(objects!, animated: true)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("PFObject")
        
        if view == nil
        {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PFObject")
            view?.canShowCallout = true
        }
        else
        {
            view?.annotation = annotation
        }
        
        view?.leftCalloutAccessoryView = nil
        if let pf = annotation as? PFObject
        {
            if pf.image != nil
            {
                view?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
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
