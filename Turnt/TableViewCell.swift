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
} // A

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    
    var delegate:TableViewCellDelegate? = nil
    

    @IBOutlet weak var likesButton: UIButton!
    @IBAction func likeThis(sender: AnyObject) {
        delegate?.like(self)
        
        let liked = UIImage(named: "TurtleTurnt")
        likesButton.setImage(liked, forState: .Normal)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
