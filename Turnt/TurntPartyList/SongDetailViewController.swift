//
//  SongDetailViewController.swift
//  Invenire
//
//  Created by Cristián Garay on 12/5/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {

    var selectedArtist = ""
    var selectedSongName = ""
    var selectedAlbum = ""
    var selectedDistance = ""
    var selectedLikes = ""
    var selectedSharedBy = ""
    var selectedArtwork = UIImage(named: "Music")
    var check = 0
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var sharedBy: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    //var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.albumArt.image = self.image
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
        //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        //self.profileImage.clipsToBounds = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if check == 0 {
            performSegueWithIdentifier()
        }
        else {
            performSegue
        }
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
