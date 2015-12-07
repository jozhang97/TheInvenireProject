//
//  postsCellTVC.swift
//  Invenire
//
//  Created by Abhi on 12/5/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class postsCellTVC: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
