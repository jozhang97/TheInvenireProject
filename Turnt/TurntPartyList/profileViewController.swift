//
//  profileViewController.swift
//  Invenire
//
//  Created by Abhi on 12/3/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    var songTitles = [String]()
    var artistTitles = [String]()
    var albumTitles = [String]()
    var pictures = [PFFile]()
    var likes = [String]()
    
    @IBOutlet weak var postsTableView: UITableView!
    
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("logOutSegue", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        getMemberInfo()
        // Do any additional setup after loading the view.
    }
    
    func getMemberInfo() {
        var query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                    self.userNameLabel.text = "Welcome, " + (PFUser.currentUser()?.username)! + "!"
                    self.emailLabel.text = "Email: " + (PFUser.currentUser()?.email)!
                    
                    let imageFile = objects[0]["profPic"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in if error == nil {
                        let image1 = UIImage(data: imageData!)
                        self.imageLabel.image = image1
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            var query2 = PFQuery(className: "Posts")
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
            }
            //print("Array of PostIDS: ")
            //print(self.postIDs)
                self.postsTableView.reloadData()
            }
            }
        }
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = postsTableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! postsCellTVC 
        let cell = postsTableView.dequeueReusableCellWithIdentifier("postCell") as! postsCellTVC
        cell.songTitle.text = songTitles[indexPath.row]
        cell.artistTitle.text = artistTitles[indexPath.row]
        cell.albumTitle.text = albumTitles[indexPath.row]
        cell.numberOfLikes.text = likes[indexPath.row]
        
        let imageFile = pictures[indexPath.row] as! PFFile
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
    
}
