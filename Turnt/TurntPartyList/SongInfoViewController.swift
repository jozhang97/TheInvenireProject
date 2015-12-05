//
//  SongInfoViewController.swift
//  Invenire
//
//  Created by Shaili Patel on 12/5/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class SongInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        // 2
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        // 3
        imageView.addSubview(blurView)
        
        // Do any additional setup after loading the view.
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
