//
//  TableViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/1/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//f

import UIKit 

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    

    @IBAction func segmentChanged(sender: AnyObject) {
        clearArrays()
        getParties()
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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var artistNames = Array<String>()
    var songNames = Array<String> ()
    var albumNames = Array<String>()
    var likesList = Array<Int>()
    var locations = Array<PFGeoPoint>()
    var artworks = Array<UIImage>()
    var peopleNames = Array<String>()
    var selectedSongIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationController!.navigationBar.hidden = false
//        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.678, blue: 1, alpha: 1)
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? Dictionary
//        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        tableView.delegate = self
        tableView.dataSource = self
        getParties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getParties(){
        // artwork has error
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
        print("message count: ")
        print(messages!.count)
        for object in messages! {
            let artwork = object["artwork"] as! PFFile
            let image = try? UIImage(data: artwork.getData())
            self.artworks.append(image!!)
            /***
            artwork.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data:imageData!)
                    print("hello")
                    self.artworks.append(image!)
                }
            }*/
        }

        query.limit = 15
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) scores.")
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        self.artistNames.append(object["artist"] as! String)
                        self.songNames.append(object["title"] as! String)
                        self.albumNames.append(object["album"] as! String)
                        self.likesList.append(object["numLikes"] as! Int)
                        self.locations.append(object["location"] as! PFGeoPoint)
                        self.peopleNames.append(object["username"] as! String)
                        /***
                        let artwork = object["artwork"] as! PFFile
                        artwork.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    let image = UIImage(data:imageData!)
                                    print("hello")
                                    self.artworks.append(image!)
                                }
                        }
                        */
                        
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    func like (cell: TableViewCell) {
        let query = PFQuery(className:"Posts")
        query.whereKey("title", equalTo: cell.song.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        let currLikes = object["numLikes"] as! Int
//                        NSLog("Current Likes %i", currLikes)
                        let newLikes = currLikes + 1
                        object["numLikes"] = newLikes
                        object.saveInBackground()
                    }
                    self.clearArrays()
                    self.getParties() // use a wherekey (not very efficient)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! TableViewCell
//        cell.memberProfilePic.layer.cornerRadius = cell.memberProfilePic.frame.size.width/2
//        cell.memberProfilePic.clipsToBounds = true
//        cell.delegate = self
        cell.artist.text = artistNames[indexPath.row]
        cell.song.text = songNames[indexPath.row]
        cell.album.text = albumNames[indexPath.row]
        cell.likes.text = "x" + String(likesList[indexPath.row])
        cell.distance.text = "distance: "+String(findDistance(locations[indexPath.row])) + " miles away"
        print(artworks)
        print(artworks.count)
        cell.artwork.image = artworks[indexPath.row]
        // Set the text of the memberName field of the cell to the right value
        cell.delegate = self
        // Set the image of the memberProfilePic imageview in the cell
        return cell
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
        return round(100*musicLocation.distanceInMilesTo(currLocation))/100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSongIndex = indexPath.row
        self.performSegueWithIdentifier("showSongDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSongDetail"
        {
            selectedSongIndex = (self.tableView.indexPathForSelectedRow?.row)!
            
            let vc = segue.destinationViewController as! SongDetailViewController
            vc.selectedArtist = self.artistNames[selectedSongIndex]
            vc.selectedSongName = self.songNames[selectedSongIndex]
            vc.selectedAlbum  = self.albumNames[selectedSongIndex]
            vc.selectedSharedBy = "Shared by " + self.peopleNames[selectedSongIndex]
            vc.selectedDistance = String(findDistance(locations[selectedSongIndex])) + " miles away."
            vc.selectedLikes = "Like by " + String(likesList[selectedSongIndex]) + " people!"
            vc.selectedArtwork = self.artworks[selectedSongIndex]
            
        }
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
//