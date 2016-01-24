//







//  SongDetailViewController.swift







//  Invenire







//







//  Created by Cristián Garay on 12/5/15.







//  Copyright © 2015 Jeffrey Zhang. All rights reserved.







//















import UIKit















class SongDetailViewController: ViewController {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var selectedArtist = ""
    
    
    
    
    
    
    
    var selectedSongName = ""
    
    
    
    
    
    
    
    var selectedAlbum = ""
    
    
    
    
    
    
    
    var selectedDistance = ""
    
    
    
    
    
    
    
    var selectedLikes = ""
    
    
    
    
    
    
    
    var selectedSharedBy = ""
    
    
    
    
    
    var date = NSDate()
    
    
    
    
    
    var selectedArtwork = UIImage(named: "Music")
    
    
    
    
    
    
    
    var check = 0
    
    
    
    
    
    
    
    var check2 = 0
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var songLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*10/20, width: UIScreen.mainScreen().bounds.width - 80, height: 24))
    
    
    
    
    
    
    
    var artistLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*10/20 + 20, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    
    
    
    
    
    
    var albumLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*10/20 + 38, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    
    
    
    
    
    
    var likesLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*13/20, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    
    
    
    
    
    
    var sharedByLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*17.2/20, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    
    
    
    
    
    
    //    var profileImage = UIImage(frame: CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
    
    
    
    
    
    
    
    var albumArt = UIImageView(frame: CGRect(x: 30, y: 70, width: UIScreen.mainScreen().bounds.width - 60, height: UIScreen.mainScreen().bounds.height*1.45/4))
    
    
    
    
    
    
    
    var profPicFrame = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2 - 50, UIScreen.mainScreen().bounds.height*14/20, UIScreen.mainScreen().bounds.width * 1.25/5,UIScreen.mainScreen().bounds.width * 1.25/5))
    
    
    
    
    
    
    
    var timeLabel = UILabel(frame: CGRect(x: 30, y: UIScreen.mainScreen().bounds.height*17.25/20 + 17, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    
    
    
    
    
    
    //    let likesHeart = UIImage(CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
    
    
    
    
    
    
    
    //
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        
        
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if check == 0 {
            
            
            
            
            
            
            
            //performSegueWithIdentifier("back1", sender: self)
            
            
            
            
            
            
            
        }
            
            
            
            
            
            
            
        else if check == 1{
            
            
            
            
            
            
            
            //performSegueWithIdentifier("back2", sender: self)
            
            
            
            
            
            
            
        }
            
            
            
            
            
            
            
        else {
            
            
            
            
            
            
            
            //performSegueWithIdentifier("back3", sender: self)
            
            
            
            
            
            
            
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
        
        
        
        
        
        
        
        getMemberInfo()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        songLabel.text = selectedSongName
        
        
        
        
        
        
        
        artistLabel.text = selectedArtist
        
        
        
        
        
        
        
        albumLabel.text = selectedAlbum
        
        
        
        
        
        
        
        likesLabel.text = selectedLikes
        
        
        
        
        
        
        
        sharedByLabel.text = selectedSharedBy + " at " + selectedDistance
        
        
        
        
        
        
        
        albumArt.image = selectedArtwork
        
        
        
        timeLabel.text = "Posted " + String(Int(round(-1*date.timeIntervalSinceNow/60/60/24))) + " days ago"
        
        
        
        
        
        songLabel.textColor = UIColor.whiteColor()
        
        
        
        
        
        artistLabel.textColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        albumLabel.textColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        likesLabel.textColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        sharedByLabel.textColor = UIColor.whiteColor()
        
        
        
        timeLabel.textColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        
        
        
        
        songLabel.textAlignment = .Center
        
        
        
        
        
        
        
        artistLabel.textAlignment = .Center
        
        
        
        
        
        
        
        albumLabel.textAlignment = .Center
        
        
        
        
        
        
        
        likesLabel.textAlignment = .Center
        
        
        
        
        
        
        
        sharedByLabel.textAlignment = .Center
        
        
        
        timeLabel.textAlignment = .Center
        
        
        
        
        
        
        
        
        
        
        
        songLabel.font = UIFont(name: "Futura", size: 16)
        
        
        
        
        
        
        
        artistLabel.font = UIFont(name: "Futura", size: 14)
        
        
        
        
        
        
        
        albumLabel.font = UIFont(name: "Futura", size: 14)
        
        
        
        
        
        
        
        likesLabel.font = UIFont(name: "Futura", size: 14)
        
        
        
        
        
        
        
        sharedByLabel.font = UIFont(name: "Futura", size: 12)
        
        
        
        timeLabel.font = UIFont(name: "Futura", size: 12)
        
        
        
        
        
        
        
        
        
        
        
        albumArt.contentMode = .ScaleAspectFit
        
        
        
        
        
        
        
        albumArt.clipsToBounds = true
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        
        
        
        
        
        
        
        //        let blurView = UIVisualEffectView(effect: darkBlur)
        
        
        
        
        
        
        
        //        blurView.frame = albumArt.bounds
        
        
        
        
        
        
        
        //        albumArt.addSubview(blurView)
        
        
        
        
        
        
        
        //
        
        
        
        
        
        
        
        //        profileImage.image = selectedArtwork
        
        
        
        
        
        
        
        self.view.backgroundColor = UIColor.clearColor()
        
        
        
        
        
        
        
        //        profileImage.contentMode = .ScaleAspectFit
        
        
        
        
        
        
        
        //        profileImage.clipsToBounds = true
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        view.addSubview(artistLabel)
        
        
        
        
        
        
        
        view.addSubview(albumLabel)
        
        
        
        
        
        
        
        view.addSubview(likesLabel)
        
        
        
        
        
        
        
        view.addSubview(sharedByLabel)
        
        
        
        
        
        
        
        view.addSubview(songLabel)
        
        
        
        
        
        
        
        view.addSubview(albumArt)
        
        
        
        view.addSubview(timeLabel)
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        
        
        
        
        
        
        super.didReceiveMemoryWarning()
        
        
        
        
        
        
        
        // Dispose of any resources that can be recreated.
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        
        
        
        
        if segue.identifier == "back2" {
            
            
            
            
            
            
            
            let vc = segue.destinationViewController as! profileViewController
            
            
            
            
            
            
            
            if check2 == 0 {
                
                
                
                
                
                
                
                vc.currentState = 0
                
                
                
                
                
                
                
            }
                
                
                
                
                
                
                
            else {
                
                
                
                
                
                
                
                vc.currentState = 1
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getMemberInfo() {
        
        
        
        //this first query deals with loading user profile image and name
        
        
        
        let query = PFQuery(className:"_User")
        
        
        
        query.whereKey("username", equalTo: self.selectedSharedBy)
        
        
        
        query.findObjectsInBackgroundWithBlock {
            
            
            
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            
            
            if error == nil {
                
                
                
                if objects != nil{
                    
                    
                    
                    let imageFile = objects![0]["profPic"] as! PFFile
                    
                    
                    
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in if error == nil {
                        
                        
                        
                        let image1 = UIImage(data: imageData!)
                        
                        
                        
                        self.profPicFrame.image = image1
                        
                        
                        
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
                
                
                
            else {
                
                
                
                // Log details of the failure
                
                
                
                print("Error: \(error!) \(error!.userInfo)")
                
                
                
            }
            
            
            
        }
        
        
        
        
        
        
        
        profPicFrame.layer.cornerRadius = profPicFrame.frame.size.width / 2;
        
        
        
        profPicFrame.clipsToBounds = true
        
        
        
        profPicFrame.contentMode = .ScaleAspectFill
        
        
        
        
        
        
        
        profPicFrame.layer.borderWidth = 2
        
        
        
        profPicFrame.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        
        
        
        
        
        view.addSubview(profPicFrame)
        
        
        
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