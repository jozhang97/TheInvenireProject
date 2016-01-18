//
//  postsCellTVC.swift
//  Invenire
//
//  Created by Abhi on 12/5/15.
//  Copyright © 2015 Abhishek Mangla. All rights reserved.
//

import UIKit

class postsCellTVC: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "whiteheart")
        heartImageView.frame = CGRectMake(self.frame.width - 50, self.frame.height/2 - 20, 40, 40)
            
        self.addSubview(heartImageView)
        
        musicImage.frame = CGRectMake(0,0, 100, 100)
        
        songTitle.frame = CGRectMake(musicImage.frame.width + 5, self.frame.height/2 - 30, self.frame.width/2.5, 20)
        songTitle.adjustsFontSizeToFitWidth = true
        songTitle.font = UIFont(name: "Futura", size: 20)
        songTitle.textColor = UIColor.whiteColor()
        songTitle.numberOfLines = 2
        
        artistTitle.frame = CGRectMake(musicImage.frame.width + 5, self.frame.height/2, self.frame.width/2.5, 20)
        artistTitle.adjustsFontSizeToFitWidth = true
        artistTitle.textColor = UIColor.whiteColor()
        artistTitle.font = UIFont(name: "Futura", size: 12)
        
        numberOfLikes.textColor = UIColor.whiteColor()
        numberOfLikes.adjustsFontSizeToFitWidth = true
        numberOfLikes.frame = CGRectMake(self.frame.width - 37, self.frame.height/2 - 15, 30, 30)
        
        
    }

}
