//
//  MKPFObject.swift
//  Invenire
//
//  Created by Jeffrey Zhang on 1/8/16.
//  Copyright © 2016 Jeffrey Zhang. All rights reserved.
//

import Foundation
import MapKit

extension PFObject: MKAnnotation
{
    public var coordinate: CLLocationCoordinate2D
    {
        if let location = self["location"]
        {
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        else
        {
            return CLLocationCoordinate2D(latitude: 37.5483, longitude: 121.9886)
        }
    }
    
    public var title: String!
    {
        if let songName = self["title"]
        {
            return songName as! String
        }
        return "unknown title"
    }
    
    public var subtitle: String!
    {
        if let artist = self["artist"]
        {
            return artist as! String
        }
        return "unknown artist"
    }
    
    public var image: UIImage!
    {
        if let artwork = self["artwork"] as? PFFile
        {
            let image = try? UIImage(data: artwork.getData())
            return image! 
        }
        return nil
    }
}