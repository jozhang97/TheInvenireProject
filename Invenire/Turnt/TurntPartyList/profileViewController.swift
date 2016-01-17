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
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postsTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!

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
    
    func clearArrays() {
        songTitles.removeAll()
        artistTitles.removeAll()
        albumTitles.removeAll()
        pictures.removeAll()
        likes.removeAll()
        artworks.removeAll()
    }
    
    func setupButtons() {
        editButton.frame = CGRectMake(20,20,40,40)
        
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("BACK", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 50, 20, 100, 40)
        
        logoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logoutButton.setTitle("LOG OUT", forState: .Normal)
        logoutButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        logoutButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width-120, 20, 100, 40)
        
    }
    
    func setupProfile() {
        userNameLabel.font = UIFont(name: "Futura", size: 30)
        userNameLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/4, 60, UIScreen.mainScreen().bounds.width/2, 35)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.textColor = UIColor.whiteColor()
        
        imageLabel.layer.cornerRadius = imageLabel.frame.size.width / 2;
        imageLabel.clipsToBounds = true
        imageLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 75, 120, 150, 150)
        
    }
    
    func setupTable() {
        postsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        postsTableView.backgroundColor = UIColor.clearColor()
        postsTableView.backgroundView?.backgroundColor = UIColor.clearColor()
        postsTableView.backgroundView = nil
        postsTableView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/8, UIScreen.mainScreen().bounds.height * 1.7/4 + 45, UIScreen.mainScreen().bounds.width * 0.75, UIScreen.mainScreen().bounds.height*15/32)
        
        segmentControl.frame = CGRectMake(UIScreen.mainScreen().bounds.width/8, UIScreen.mainScreen().bounds.height * 1.7/4, UIScreen.mainScreen().bounds.width * 0.75, 35)
        segmentControl.tintColor = UIColor.whiteColor()
        segmentControl.setTitle("MY POSTS", forSegmentAtIndex: 0)
        segmentControl.setTitle("MY LIKES", forSegmentAtIndex: 1)
        segmentControl.backgroundColor = UIColor.clearColor()
        segmentControl.layer.borderColor = UIColor.whiteColor().CGColor
        segmentControl.layer.borderWidth = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        setupButtons()
        setupProfile()
        setupTable()
        
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
                if objects != nil{
                    self.userNameLabel.text = "WELCOME " + (PFUser.currentUser()?.username)! + "!"
                    
                    let imageFile = objects![0]["profPic"] as! PFFile
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        postsTableView?.deselectRowAtIndexPath(indexPath, animated: true)
        selectedSongIndex = indexPath.row
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = nil
        cell.backgroundView?.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = postsTableView.dequeueReusableCellWithIdentifier("postCell") as! postsCellTVC
        cell.songTitle.text = songTitles[indexPath.row]
        cell.artistTitle.text = artistTitles[indexPath.row]
        //cell.albumTitle.text = albumTitles[indexPath.row]
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
        return 120
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
