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

class AddSongViewController: ViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var currentLocation = CLLocation!()
    var musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    @IBOutlet weak var sharemusicLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var albumArt = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2 - UIScreen.mainScreen().bounds.width/6, UIScreen.mainScreen().bounds.height/2 - UIScreen.mainScreen().bounds.height/6, UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.height/3))
    @IBOutlet weak var songTitle = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2 - UIScreen.mainScreen().bounds.width/6, UIScreen.mainScreen().bounds.height/2 - UIScreen.mainScreen().bounds.height/6 + UIScreen.mainScreen().bounds.height/3 + UIScreen.mainScreen().bounds.height/10, UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.height/15))
    @IBOutlet weak var artistName = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2 - UIScreen.mainScreen().bounds.width/6, UIScreen.mainScreen().bounds.height/2 - UIScreen.mainScreen().bounds.height/6 + UIScreen.mainScreen().bounds.height/3 + UIScreen.mainScreen().bounds.height/5, UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.height/15))
    @IBOutlet weak var albumName = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2 - UIScreen.mainScreen().bounds.width/6, UIScreen.mainScreen().bounds.height/2 - UIScreen.mainScreen().bounds.height/6 + UIScreen.mainScreen().bounds.height/3 + UIScreen.mainScreen().bounds.height*3/10, UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.height/15))
    
    @IBOutlet weak var background = UIImageView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))

    func setupView() {
        if let backgroundView = background
        {
            backgroundView.backgroundColor = UIColor.clearColor()

        }
        
    }
    
    @IBAction func shareMusic(sender: AnyObject) {
        
        let myPost = PFObject(className:"Posts")
        let point = PFGeoPoint(location: currentLocation)
        
        print(musicPlayer.nowPlayingItem != nil)
        if let nowPlaying = musicPlayer.nowPlayingItem
        {
            
            let title = nowPlaying.valueForProperty(MPMediaItemPropertyTitle) as? String
            let artist = nowPlaying.valueForProperty(MPMediaItemPropertyArtist) as? String
            let album = nowPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String
//            let imageData = UIImagePNGRepresentation(self.albumArt!.image!)
            
            
            let artwork = PFFile(name: "artwork", data: UIImageJPEGRepresentation(self.albumArt!.image!, 0.5)!)
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
            performSegueWithIdentifier("submitParty", sender: UIStoryboardSegue.self)
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
        setupView()
        getNowplayinginfo()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locationManager.location
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func getNowplayinginfo() {
        let diceRoll = Int(arc4random_uniform(6) + 1)
        if let nowPlaying = musicPlayer.nowPlayingItem {
            let title = nowPlaying[MPMediaItemPropertyTitle] as? String
            let artist = nowPlaying[MPMediaItemPropertyArtist] as? String
            let album = nowPlaying[MPMediaItemPropertyAlbumTitle] as? String
            var artwork: UIImage!
            
            /* copyright issues here!
            let size = CGSize(width: 300, height: 300)
            if let art = nowPlaying.valueForProperty(MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                artwork = art.imageWithSize(size)
            }
            */
            
            if artwork == nil {
                artwork = UIImage(named: "Music\(diceRoll).png")!
            }
            
            songTitle!.text = title
            artistName!.text = artist
            albumName!.text = album
            if let imageView = albumArt
            {
                 imageView.image = artwork
            }
            
            
            
            let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = view.bounds
//            self.background!.image = artwork
// 
//            // background is nil
//            background!.addSubview(blurView)
//            
            
            
        } else {
            let titleName = UILabel(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height*1/4, UIScreen.mainScreen().bounds.width - 20, 50))
//            titleName.text = "NO SONG BEING PLAYED ON iTUNES!"
            titleName.font = UIFont(name: "Futura", size: 20)
            titleName.textColor = UIColor.whiteColor()
            titleName.textAlignment = .Center
            titleName.backgroundColor = UIColor.clearColor()
            
            view.addSubview(titleName)
            let artwork = UIImage(named: "Music\(diceRoll).png")!
            
            if let imageView = albumArt
            {
                imageView.image = artwork
            }
            if let songLabel = songTitle
            {
                songLabel.text = "No Song Playing"
            }
            if let artistNameLabel = artistName
            {
                artistNameLabel.text = ""
            }
            if let albumNameLabel = albumName
            {
                 albumNameLabel.text = ""
            }
           
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
