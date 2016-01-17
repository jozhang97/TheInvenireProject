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
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var sharedBy: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
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
        self.artist.text = selectedArtist + " - " + selectedSongName
        self.album.text = selectedAlbum
        self.likes.text = selectedLikes
        self.sharedBy.text = selectedSharedBy + " at " + selectedDistance
        self.albumArt.image = selectedArtwork
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = albumArt.bounds
        albumArt.addSubview(blurView)
        
        self.profileImage.image = selectedArtwork
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
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
