//
//  TableViewCell.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/2/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit
protocol TableViewCellDelegate{ // A
    func like(cell: TableViewCell) // A
    func check(cell: TableViewCell)->Int // A
} // A

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    var delegate:TableViewCellDelegate? = nil
    
    @IBAction func likeThis(sender: AnyObject) {
        delegate?.like(self)
        likeButton.frame = CGRectMake(self.frame.width - 37, self.frame.height/2 - 25, 30, 30)
        if delegate?.check(self) == 0 {
            likeButton.setImage(UIImage(named: "whiteheart"), forState: .Normal)
            likes.textColor = UIColor.whiteColor()
        }
        else {
            likeButton.setImage(UIImage(named: "fullwhiteheart"), forState: .Normal)
            likes.textColor = UIColor.blackColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        likeButton.layer.zPosition = 0
        likes.layer.zPosition = 1
        
        artwork.frame = CGRectMake(0,0, 100, 100)
        
        song.frame = CGRectMake(120, self.frame.height/2 - 30, self.frame.width/2, 20)
        
        song.font = UIFont(name: "Futura", size: 15)
        song.adjustsFontSizeToFitWidth = true
        song.textColor = UIColor.whiteColor()
        
        artist.frame = CGRectMake(120, self.frame.height/2, self.frame.width/2, 20)
        artist.adjustsFontSizeToFitWidth = true
        artist.textColor = UIColor.whiteColor()
        artist.font = UIFont(name: "Futura", size: 12)
        
        likes.adjustsFontSizeToFitWidth = true
        likes.frame = CGRectMake(self.frame.width - 27, self.frame.height/2 - 20, 20, 20)
        self.bringSubviewToFront(likes)
    }
}
