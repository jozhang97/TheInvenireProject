//
//  ViewController.swift
//  sharePostInvenire
//
//  Created by Franky G on 11/22/15.
//  Copyright © 2015 Franky G. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
import MediaPlayer

class AddSongViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate,  UINavigationControllerDelegate {

    var locationManager: CLLocationManager!
    var currentLocation = CLLocation!()
    var musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    @IBOutlet weak var back: UIButton!
    @IBAction func back(sender: AnyObject) {
        self.performSegueWithIdentifier("shareToFeed", sender: self)
    }
    @IBAction func shareMusic(sender: AnyObject) {
        let myPost = PFObject(className:"Posts")
        let point = PFGeoPoint(location: currentLocation)
        
        print(musicPlayer.nowPlayingItem != nil)
        if let nowPlaying = musicPlayer.nowPlayingItem {
            let title = nowPlaying.valueForProperty(MPMediaItemPropertyTitle) as? String
            let artist = nowPlaying.valueForProperty(MPMediaItemPropertyArtist) as? String
            let album = nowPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String
            let imageData = UIImagePNGRepresentation(self.albumArt.image!)
            let artwork = PFFile(data: imageData!)
            print(title != nil)
            print(artist != nil)
            print(album != nil)
            print(artwork != nil)
            myPost["title"] = title
            myPost["artist"] = artist
            myPost["album"] = album
            myPost["artwork"] = artwork
            if PFUser.currentUser()!.username == "" {
                myPost["username"] = PFUser.currentUser()!["Name"]
            } else {
                myPost["username"] = PFUser.currentUser()!.username
            }
            myPost["numLikes"] = 0
            myPost["location"] = point
            myPost.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("success")
                } else {
                    // There was a problem, check error.description
                    print("error")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getNowplayinginfo()
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locationManager.location
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func getNowplayinginfo() {
        if let nowPlaying = musicPlayer.nowPlayingItem {
            let title = nowPlaying[MPMediaItemPropertyTitle] as? String
            let artist = nowPlaying[MPMediaItemPropertyArtist] as? String
            let album = nowPlaying[MPMediaItemPropertyAlbumTitle] as? String
            var artwork: UIImage!
            let size = CGSize(width: 300, height: 300)
            if let art = nowPlaying.valueForProperty(MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                artwork = art.imageWithSize(size)
            }
            
            if artwork == nil {
                artwork = UIImage(named: "placeholderimage.png")
            }
            
            songTitle.text = title
            artistName.text = artist
            albumName.text = album
            albumArt.image = artwork
        } else {
            albumArt.image = UIImage(named: "placeholderimage.png")
            songTitle.text = "Unknown"
            artistName.text = "Unknown"
            albumName.text = "Unknown"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
