//
//  LaunchViewController.swift
//  Invenire
//
//  Created by Jeffrey Zhang on 1/22/16.
//  Copyright © 2016 Jeffrey Zhang. All rights reserved.
//

import UIKit

class LaunchViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLogo()
        loadLabel()
        
        // Do any additional setup after loading the view.
    }
    
    func loadLogo ()
    {
        let imageView = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width*1/10, UIScreen.mainScreen().bounds.height/2, UIScreen.mainScreen().bounds.width*8/10, UIScreen.mainScreen().bounds.height*3/10))
        imageView.image = UIImage(named: "AppIcon")
        view.addSubview(imageView)
    }
    
    
    
    func loadLabel()
    {
        let titleName = UILabel(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height*1/4, UIScreen.mainScreen().bounds.width - 20, 50))
        titleName.text = "INVENIRE"
        titleName.font = UIFont(name: "Futura", size: 60)
        titleName.textColor = UIColor.whiteColor()
        titleName.textAlignment = .Center
        view.addSubview(titleName)
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
