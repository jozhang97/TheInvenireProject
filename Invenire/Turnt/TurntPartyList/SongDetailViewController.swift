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
    
    var selectedArtwork = UIImage(named: "Music")
    
    var check = 0
    
    var check2 = 0
    
    
    
    var songLabel = UILabel(frame: CGRect(x: 40, y: 250, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    var artistLabel = UILabel(frame: CGRect(x: 40, y: 265, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    var albumLabel = UILabel(frame: CGRect(x: 40, y: 280, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    var likesLabel = UILabel(frame: CGRect(x: 40, y: 335, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    var sharedByLabel = UILabel(frame: CGRect(x: 40, y: 350, width: UIScreen.mainScreen().bounds.width - 80, height: 20))
    
    //    var profileImage = UIImage(frame: CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
    
    var albumArt = UIImageView(frame: CGRect(x: 40, y: 80, width: UIScreen.mainScreen().bounds.width - 80, height: 150))
    
    //    let likesHeart = UIImage(CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
    
    //
    
    @IBAction func backPressed(sender: AnyObject) {
        
        if check == 0 {
            
            performSegueWithIdentifier("back1", sender: self)
            
        }
            
        else if check == 1{
            
            performSegueWithIdentifier("back2", sender: self)
            
        }
            
        else {
            
            performSegueWithIdentifier("back3", sender: self)
            
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
        
        
        
        
        
        songLabel.text = selectedSongName
        
        artistLabel.text = selectedArtist
        
        albumLabel.text = selectedAlbum
        
        likesLabel.text = selectedLikes
        
        sharedByLabel.text = selectedSharedBy + " at " + selectedDistance
        
        albumArt.image = selectedArtwork
        
        
        
        songLabel.textColor = UIColor.whiteColor()
        
        artistLabel.textColor = UIColor.whiteColor()
        
        albumLabel.textColor = UIColor.whiteColor()
        
        likesLabel.textColor = UIColor.whiteColor()
        
        sharedByLabel.textColor = UIColor.whiteColor()
        
        
        
        songLabel.textAlignment = .Center
        
        artistLabel.textAlignment = .Center
        
        albumLabel.textAlignment = .Center
        
        likesLabel.textAlignment = .Center
        
        sharedByLabel.textAlignment = .Center
        
        
        
        songLabel.font = UIFont(name: "Futura-Bold", size: 14)
        
        artistLabel.font = UIFont(name: "Futura", size: 13)
        
        albumLabel.font = UIFont(name: "Futura", size: 13)
        
        likesLabel.font = UIFont(name: "Futura", size: 13)
        
        sharedByLabel.font = UIFont(name: "Futura", size: 13)
        
        
        
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
    
    /*
    
    // MARK: - Navigation
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // Get the new view controller using segue.destinationViewController.
    
    // Pass the selected object to the new view controller.
    
    }
    
    */
    
    
    
}