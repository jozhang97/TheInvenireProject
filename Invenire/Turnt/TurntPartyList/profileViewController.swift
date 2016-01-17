//
//  profileViewController.swift
//  Invenire
//
//  Created by Abhi on 12/3/15.
//  Copyright © 2015 Abhishek Mangla. All rights reserved.
//

import UIKit

class profileViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    var songTitles = [String]()
    var artistTitles = [String]()
    var albumTitles = [String]()
    var pictures = [PFFile]()
    var locations = [PFGeoPoint]()
    var peopleNames = [String]()
    var likes = [String]()
    var selectedSongIndex = 0
    var artworks = [UIImage]()
    var currentState = 0
    
    @IBOutlet weak var profbgImageView: UIImageView!
    @IBOutlet weak var postsTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    func clearArrays() {
        songTitles.removeAll()
        artistTitles.removeAll()
        albumTitles.removeAll()
        pictures.removeAll()
        likes.removeAll()
        artworks.removeAll()
    }

    @IBAction func segmentControlAction(sender: AnyObject) {
        if segmentControl.selectedSegmentIndex == 0 {
            clearArrays()
            getMemberInfoPosts()
        }
        else {
            clearArrays()
            currentState = 1
            getMemberInfoLikes()
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("logOutSegue", sender: nil)
        }
    }
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        postsTableView.delegate = self
        postsTableView.dataSource = self
        let count = Int(arc4random_uniform(5) + 1)
        profbgImageView.image = UIImage(named: "profbg\(count)")
        imageLabel.bringSubviewToFront(profbgImageView)
        // Create a white border with defined width
        imageLabel.layer.borderColor = UIColor.blackColor().CGColor
        imageLabel.layer.borderWidth = 3;
        
        // Set image corner radius
        imageLabel.layer.cornerRadius = 5.0;
        
        // To enable corners to be "clipped"
        imageLabel.clipsToBounds = true
        
        profbgImageView.layer.borderColor = UIColor.blackColor().CGColor
        profbgImageView.layer.borderWidth = 5;
        
        if currentState == 0 {
            segmentControl.selectedSegmentIndex = 0
            getMemberInfo()
            getMemberInfoPosts()
        }
        else {
            segmentControl.selectedSegmentIndex = 1
            getMemberInfo()
            getMemberInfoLikes()
        }
        postsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func getMemberInfoLikes() {
        let query2 = PFQuery(className: "Posts")
        var postsLiked = [String] ()
        if let a = PFUser.currentUser()!["postsLiked"] {
            postsLiked = a as! [String]
        }
        query2.whereKey("objectId", containedIn: postsLiked)
        //deleted stuff here
        
        query2.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("number of objects: " + String(objects!.count))
                for object in objects! {
                    self.songTitles.append(object["title"] as! (String))
                    self.artistTitles.append(object["artist"] as! (String))
                    self.albumTitles.append(object["album"] as! (String))
                    self.likes.append(String(object["numLikes"]))
                    self.pictures.append(object["artwork"] as! PFFile)
                    self.locations.append(object["location"] as! PFGeoPoint)
                    self.peopleNames.append(object["username"] as! String)
                    let artwork = object["artwork"] as! PFFile
                    let image = try? UIImage(data: artwork.getData())
                    self.artworks.append(image!!)
                }
                self.postsTableView.reloadData()
            }
        }
    }

    func getMemberInfo() {
        //this first query deals with loading user profile image and name
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects! as? [PFObject] {
                    self.userNameLabel.text = "Welcome " + (PFUser.currentUser()?.username)! + "!"
                    
                    let imageFile = objects[0]["profPic"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in if error == nil {
                            let image1 = UIImage(data: imageData!)
                            self.imageLabel.image = image1
                        }
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getMemberInfoPosts() {
            //second query deals with loading table with posts that user has made.
            let query2 = PFQuery(className: "Posts")
            query2.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
                query2.orderByAscending("createdAt")
                query2.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                            self.songTitles.append(object["title"] as! (String))
                            self.artistTitles.append(object["artist"] as! (String))
                            self.albumTitles.append(object["album"] as! (String))
                            self.likes.append(String(object["numLikes"]))
                            self.pictures.append(object["artwork"] as! PFFile)
                            self.locations.append(object["location"] as! PFGeoPoint)
                            self.peopleNames.append(object["username"] as! String)
                            let artwork = object["artwork"] as! PFFile
                            let image = try? UIImage(data: artwork.getData())
                            self.artworks.append(image!!)
                        }
                        self.postsTableView.reloadData()
                    }
            }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSection = 0
        if self.songTitles.count > 0 {
            self.postsTableView.backgroundView = nil
            numOfSection = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.postsTableView.bounds.size.width, self.postsTableView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.postsTableView.backgroundView = noDataLabel
        }
        return numOfSection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = postsTableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! postsCellTVC 
        let cell = postsTableView.dequeueReusableCellWithIdentifier("postCell") as! postsCellTVC
        cell.songTitle.text = songTitles[indexPath.row]
        cell.artistTitle.text = artistTitles[indexPath.row]
        cell.albumTitle.text = albumTitles[indexPath.row]
        cell.numberOfLikes.text = likes[indexPath.row]
        
        let imageFile = pictures[indexPath.row] 
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in if error == nil {
                let image1 = UIImage(data: imageData!)
                cell.musicImage.image = image1
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songTitles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSongIndex = indexPath.row
        //self.performSegueWithIdentifier("moreSongDetail2", sender: self)
    }

    func findLocation() -> PFGeoPoint {
        
        var currLocation = PFGeoPoint(latitude:40.0, longitude:-30.0)
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                currLocation = geoPoint!
            }
        }
        return currLocation
    }
    
    func findDistance(musicLocation :PFGeoPoint) -> Double {
        let currLocation = findLocation()
        print(currLocation)
        print(musicLocation)
        return round(100*musicLocation.distanceInMilesTo(currLocation))/100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moreSongDetail"
        {
            selectedSongIndex = (self.postsTableView.indexPathForSelectedRow?.row)!
            let vc = segue.destinationViewController as! SongDetailViewController
            vc.selectedArtist = self.artistTitles[selectedSongIndex]
            vc.selectedSongName = self.songTitles[selectedSongIndex]
            vc.selectedAlbum  = self.albumTitles[selectedSongIndex]
            vc.selectedSharedBy = "Shared by " + self.peopleNames[selectedSongIndex]
            vc.selectedDistance = String(findDistance(locations[selectedSongIndex])) + " miles away."
            vc.selectedLikes = "Liked by " + String(likes[selectedSongIndex]) + " people!"
            vc.selectedArtwork = self.artworks[selectedSongIndex]
            vc.check = 1
            if currentState == 0 {
                vc.check2 = 0
            }
            else {
                vc.check2 = 1
            }
            
        }
    }
    
}
