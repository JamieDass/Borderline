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
    let levelStrings: NSArray = ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]

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
        let defaults = UserDefaults.standard
        defaults.set(7, forKey: "score")
        RootVC().updateLabel()
        self.navigationItem.title = "Challenge"
        let levelButtons: NSArray = [level1Button,level2Button,level3Button,level4Button,level5Button,level6Button]
        for button in levelButtons{
            (button as AnyObject).layer.cornerRadius = 13
            (button as AnyObject).layer.borderWidth = 4.0
            (button as AnyObject).layer.backgroundColor = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0).cgColor
            (button as AnyObject).layer.borderColor = UIColor.orange.cgColor
            (button as AnyObject).titleLabel??.numberOfLines = 1
            (button as AnyObject).titleLabel??.adjustsFontSizeToFitWidth = true
            (button as AnyObject).titleLabel??.lineBreakMode = NSLineBreakMode.byClipping
            (button as AnyObject).titleLabel??.textColor = UIColor.orange
            (button as AnyObject).titleLabel??.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            //            button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        LevelVC *targetVC = segue.destinationViewController
        if let destination = segue.destination as? LevelVC{
            destination.levelName = levelStrings[(sender! as AnyObject).tag] as! NSString
            destination.levelNumber = sender!.tag+1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
