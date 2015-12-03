//
//  TableViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/1/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//f

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
    var artistNames = Array<String>()
    var songNames = Array<String> ()
    var albumNames = Array<String>()
    var likesList = Array<Int>()
    
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
        //getDescription()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getParties(){
        let query = PFQuery(className:"Songs")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        self.artistNames.append(object["Artist"] as! String)
                        self.songNames.append(object["Song"] as! String)
                        self.albumNames.append(object["Album"] as! String)
                        self.likesList.append(object["likes"] as! Int)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // error in this
    func like (cell: TableViewCell) {
        let query = PFQuery(className:"Songs")
        query.whereKey("Song", equalTo: cell.song.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    for object in objects {
                        let currLikes = object["likes"] as! Int
                        let newLikes = currLikes + 1
                        object["likes"] = newLikes
                        object.saveInBackgroundWithBlock { (succeeded, signupError) -> Void in
                            if signupError == nil{
                                self.performSegueWithIdentifier("likeSegue", sender: nil)
                            }
                        }
                    }
                    self.tableView.reloadData()
                    //  viewDidLoad()
                    
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
        cell.distance.text = "distance of thing is 10 mi"
        // Set the text of the memberName field of the cell to the right value
        
        
        // Set the image of the memberProfilePic imageview in the cell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
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