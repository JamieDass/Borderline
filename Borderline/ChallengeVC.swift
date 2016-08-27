//
//  ChallengeVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-21.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit


class ChallengeVC: UIViewController {
    
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    @IBOutlet weak var level4Button: UIButton!
    @IBOutlet weak var level5Button: UIButton!
    @IBOutlet weak var level6Button: UIButton!
    @IBOutlet weak var scoreLab: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.parentViewController!.parentViewController!.view.viewWithTag(1)!.backgroundColor = UIColor.orangeColor()
//        let vc = RootVC()
//        vc.score = "now"
//        vc.updateLabel()
//        RootVC().viewDidLoad()
        
//        RootVC().score = "ahoy"

//        RootVC().updateLabel("ahoy")
//        RootVC().setValue("ahoy", forKey: scorel)
//        scoreView.backgroundColor = UIColor.orangeColor()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(7, forKey: "score")
        RootVC().updateLabel()
        self.navigationItem.title = "Challenge"
        let levelButtons: NSArray = [level1Button,level2Button,level3Button,level4Button,level5Button,level6Button]
        for button in levelButtons{
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 4.0
            button.layer.backgroundColor = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0).CGColor
            button.layer.borderColor = UIColor.orangeColor().CGColor
            button.titleLabel??.numberOfLines = 1
            button.titleLabel??.adjustsFontSizeToFitWidth = true
            button.titleLabel??.lineBreakMode = NSLineBreakMode.ByClipping
            button.titleLabel??.textColor = UIColor.orangeColor()
            button.titleLabel??.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
            //            button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        LevelVC *targetVC = segue.destinationViewController
        if let destination = segue.destinationViewController as? LevelVC{
            destination.levelName = "Level 1"
            destination.levelNumber = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
