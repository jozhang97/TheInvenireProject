//
//  AboutViewController.swift
//  Invenire
//
//  Created by Jeffrey Zhang on 1/21/16.
//  Copyright © 2016 Jeffrey Zhang. All rights reserved.
//

import UIKit

class AboutViewController: ViewController {

    var infoLabel = UILabel(frame: CGRect(x: 20, y: 90, width: UIScreen.mainScreen().bounds.width - 40, height: 80))
    var aboutLabel = UILabel(frame: CGRect(x: 20, y: 30, width: UIScreen.mainScreen().bounds.width - 40, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = "This app was developed by Abhi Mangla, Jeffrey Zhang, Franky Guerrero, Shaili Patel, and Cristian Garay. Thanks to Akkshay Khoslaa and Virindh Borra."
        infoLabel.numberOfLines = 6
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        infoLabel.textColor = UIColor.whiteColor()
        aboutLabel.text = "About"
        
        infoLabel.font = UIFont(name: "Futura", size: 14)
        aboutLabel.font = UIFont(name: "Futura", size: 28)
        aboutLabel.textColor = UIColor.whiteColor()
        
        
        aboutLabel.textAlignment = .Left
        infoLabel.textAlignment = .Left
        
        view.addSubview(infoLabel)
        view.addSubview(aboutLabel)
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
