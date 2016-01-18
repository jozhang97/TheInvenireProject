//
//  TableViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/1/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//f

import UIKit 

class TableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UINavigationControllerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let bufferView = UIActivityIndicatorView (frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2, 20, 20))
    var artistNames = Array<String>()
    var songNames = Array<String> ()
    var albumNames = Array<String>()
    var likesList = Array<Int>()
    var locations = Array<PFGeoPoint>()
    var artworks = Array<UIImage>()
    var peopleNames = Array<String>()
    var selectedSongIndex = 0
    
    @IBAction func segmentChanged(sender: AnyObject) {
        clearArrays()
        getParties()
    }
    
    func setupTop() {
        discoverLabel.text = "DISCOVER"
        discoverLabel.font = UIFont(name: "Futura", size: 30)
        discoverLabel.textColor = UIColor.whiteColor()
        discoverLabel.textAlignment = .Center
        discoverLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 100, 20, 200, 40)
        
        
        profileButton.frame = CGRectMake(20, 15, 50, 50)
        
        shareButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width-70, 15, 50, 50)
        view.addSubview(bufferView)
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        getParties()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/10, UIScreen.mainScreen().bounds.height * 1/10 + 45, UIScreen.mainScreen().bounds.width * 8/10, UIScreen.mainScreen().bounds.height*25/32)
        
        segmentControl.frame = CGRectMake(UIScreen.mainScreen().bounds.width/8, UIScreen.mainScreen().bounds.height * 1/10, UIScreen.mainScreen().bounds.width * 8/10, 40)
        segmentControl.tintColor = UIColor.whiteColor()
        segmentControl.setTitle("POPULAR", forSegmentAtIndex: 0)
        segmentControl.setTitle("RECENT", forSegmentAtIndex: 1)
        segmentControl.setTitle("NEAR ME", forSegmentAtIndex: 2)
        segmentControl.backgroundColor = UIColor.clearColor()
        segmentControl.layer.borderColor = UIColor.whiteColor().CGColor
        segmentControl.layer.borderWidth = 2
        UISegmentedControl.appearance().setTitleTextAttributes(NSDictionary(objects: [UIFont.systemFontOfSize(14.0)], forKeys: [NSFontAttributeName]) as [NSObject : AnyObject], forState: UIControlState.Normal)
        //You have to set the resizes text property to the right settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // new
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // end new
        setupTop()
        setupTable()
    }
    
    func clearArrays(){
        artistNames = Array<String>()
        songNames = Array<String>()
        albumNames = Array<String>()
        likesList = Array<Int>()
        locations = Array<PFGeoPoint>()
        artworks = Array<UIImage>()
        peopleNames = Array<String>()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getParties(){
        // artwork has error
        bufferView.startAnimating()
        let query = PFQuery(className:"Posts")
        if segmentControl.selectedSegmentIndex == 0 {
            query.addDescendingOrder("numLikes")
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            query.addDescendingOrder("createdAt")
        }
        else if segmentControl.selectedSegmentIndex == 2{
            query.whereKey("location", nearGeoPoint: findLocation())
        }
        /***
        Something wrong with images and synchronous queries
        */
        let messages = try? query.findObjects()
        query.whereKey("location", nearGeoPoint: findLocation(), withinMiles: 100)
        query.limit = 15
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects != nil {
                    for object in objects! {
                        self.artistNames.append(object["artist"] as! String)
                        self.songNames.append(object["title"] as! String)
                        self.albumNames.append(object["album"] as! String)
                        self.likesList.append(object["numLikes"] as! Int)
                        self.locations.append(object["location"] as! PFGeoPoint)
                        self.peopleNames.append(object["username"] as! String)
                        let artwork = object["artwork"] as! PFFile
                        let image = try? UIImage(data: artwork.getData())
                        self.artworks.append(image!!)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        bufferView.stopAnimating()
    }
    
    func check(cell:TableViewCell) -> Int {
        let query = PFQuery(className:"Posts")
        var answer = 0
        query.whereKey("title", equalTo: cell.song.text!)
        let messages = try? query.findObjects()
        var liableUser = ""
        for object in messages! {
            if object["usersLiked"] == nil {
                
            }
            else {
                for user in object["usersLiked"] as! NSArray {
                    if user as! String == (PFUser.currentUser()?.username!)! {
                        liableUser = user as! String
                    }
                }
            }
        }
        if liableUser == "" {
            answer = 0
        }
        else {
            answer = 1
        }
        return answer
    }

    func checker(songTitle:String) -> Int {
        let query = PFQuery(className:"Posts")
        var answer = 0
        query.whereKey("title", equalTo: songTitle)
        let messages = try? query.findObjects()
        var liableUser = ""
        for object in messages! {
            if object["usersLiked"] == nil {
                
            }
            else {
                for user in object["usersLiked"] as! NSArray {
                    if user as! String == (PFUser.currentUser()?.username!)! {
                    liableUser = user as! String
                    }
                }
            }
        }
        if liableUser == "" {
            answer = 1
        }
        else {
            answer = 0
        }
        return answer
    }

    func like (cell: TableViewCell) {
        let query = PFQuery(className:"Posts")
        query.whereKey("title", equalTo: cell.song.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // Do something with the found objects
                if objects != nil {
                    for object in objects! {
                        if object["usersLiked"] == nil {
                            let currLikes = object["numLikes"] as! Int
                            //                        NSLog("Current Likes %i", currLikes)
                            let newLikes = currLikes + 1
                            object["numLikes"] = newLikes
                            object.addUniqueObject((PFUser.currentUser()?.username!)!, forKey: "usersLiked")
                            PFUser.currentUser()!.addUniqueObject(object.objectId!, forKey: "postsLiked")
                            PFUser.currentUser()?.saveInBackground()
                            object.saveInBackground()
                        }
                        else {
                            var liableUser = ""
                            for user in object["usersLiked"] as! NSArray {
                                if user as! String == (PFUser.currentUser()?.username!)! {
                                    liableUser = user as! String
                                }
                            }
                            let currLikes = object["numLikes"] as! Int
                            if liableUser == "" {
                                let newLikes = currLikes + 1
                                object["numLikes"] = newLikes
                                object.addUniqueObject((PFUser.currentUser()?.username!)!, forKey: "usersLiked")
                                PFUser.currentUser()!.addUniqueObject(object.objectId!, forKey: "postsLiked")
                                PFUser.currentUser()?.saveInBackground()
                                object.saveInBackground()
                                
                            }
                            else {
                                //displayError = "You have already liked this post!"
                                //self.displayAlert("Impossible Action", displayError: displayError)
                                let newLikes = currLikes - 1
                                object["numLikes"] = newLikes
                                object.removeObject((PFUser.currentUser()?.username!)!, forKey: "usersLiked")
                                PFUser.currentUser()!.removeObject(object.objectId!, forKey: "postsLiked")
                                PFUser.currentUser()?.saveInBackground()
                                object.saveInBackground()
                                
                            }
                        }
                    }
                    self.clearArrays()
                    self.getParties() // use a wherekey (not very efficient)
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func displayAlert(title: String, displayError: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSection = 0
        if songNames.count > 0 {
            tableView.backgroundView = nil
            numOfSection = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            tableView.backgroundView = noDataLabel
        }
        return numOfSection
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedSongIndex = indexPath.row
        self.performSegueWithIdentifier("showSongDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = nil
        cell.backgroundView?.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! TableViewCell
            cell.artist.text = artistNames[indexPath.row]
            cell.song.text = songNames[indexPath.row]
            //cell.album.text = albumNames[indexPath.row]
            cell.likes.text = String(likesList[indexPath.row])
            //cell.distance.text = "distance: "+String(findDistance(locations[indexPath.row])) + " miles away"
            cell.artwork.image = artworks[indexPath.row]
            // Set the text of the memberName field of the cell to the right value
            cell.likeButton.frame = CGRectMake(cell.frame.width - 37, cell.frame.height/2 - 25, 30, 30)
            cell.bringSubviewToFront(cell.likes)
            cell.likeButton.layer.zPosition = 0
            cell.likes.layer.zPosition = 1
        
            if checker(cell.song.text!) == 0 {
                cell.likeButton.setImage(UIImage(named: "fullwhiteheart"), forState: .Normal)
                cell.likes.textColor = UIColor.blackColor()
            }
            else {
                cell.likeButton.setImage(UIImage(named: "whiteheart"), forState: .Normal)
                cell.likes.textColor = UIColor.whiteColor()
            }
        
        
        //cell.delegate = self
        // Set the image of the memberProfilePic imageview in the cell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func findLocation() -> PFGeoPoint {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        let currLocation = locationManager.location
        let currLocationGeoPoint = PFGeoPoint(location: currLocation)
        return currLocationGeoPoint
    }
    
    func findDistance(musicLocation :PFGeoPoint) -> Double {
        let currLocation = findLocation()
        return round(100*musicLocation.distanceInMilesTo(currLocation))/100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSongDetail"
        {
            let vc = segue.destinationViewController as! SongDetailViewController
            vc.selectedArtist = self.artistNames[selectedSongIndex]
            vc.selectedSongName = self.songNames[selectedSongIndex]
            vc.selectedAlbum  = self.albumNames[selectedSongIndex]
            vc.selectedSharedBy = "Shared by " + self.peopleNames[selectedSongIndex]
            vc.selectedDistance = String(findDistance(locations[selectedSongIndex])) + " miles away."
            vc.selectedLikes = "Liked by " + String(likesList[selectedSongIndex]) + " people!"
            vc.selectedArtwork = self.artworks[selectedSongIndex]
            vc.check = 0    //not needed but to re-ensure
        }
    }

}