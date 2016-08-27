//
//  ViewController.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-20.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var extraLevelsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var challengeWidth: NSLayoutConstraint!
    @IBOutlet weak var extraLevelsWidth: NSLayoutConstraint!
    @IBOutlet weak var settingsWidth: NSLayoutConstraint!
    @IBOutlet weak var creditsWidth: NSLayoutConstraint!

    struct MyConstraint {
        static func changeMultiplier(constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
            let newConstraint = NSLayoutConstraint(
                item: constraint.firstItem,
                attribute: constraint.firstAttribute,
                relatedBy: constraint.relation,
                toItem: constraint.secondItem,
                attribute: constraint.secondAttribute,
                multiplier: multiplier,
                constant: constraint.constant)
            
            newConstraint.priority = constraint.priority
            
            NSLayoutConstraint.deactivateConstraints([constraint])
            NSLayoutConstraint.activateConstraints([newConstraint])
            
            return newConstraint
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewControllerWithIdentifier("RootVC")
//        self.presentViewController(controller, animated: true, completion: nil)
//        RootVC().scoreLabel.text = "ahem"

        
        self.navigationItem.title = "Borderline"
        let homeConstraints: NSArray = [challengeWidth,extraLevelsWidth,settingsWidth,creditsWidth]

    let isiPad: Bool = (UIDevice.currentDevice().userInterfaceIdiom == .Pad);
        if ( isiPad )
        {
            challengeWidth = MyConstraint.changeMultiplier(challengeWidth, multiplier: 0.75)
            extraLevelsWidth = MyConstraint.changeMultiplier(extraLevelsWidth, multiplier: 0.75)
            settingsWidth = MyConstraint.changeMultiplier(settingsWidth, multiplier: 0.75)
            creditsWidth = MyConstraint.changeMultiplier(creditsWidth, multiplier: 0.75)
        }else{
            challengeWidth = MyConstraint.changeMultiplier(challengeWidth, multiplier: 0.93)
            extraLevelsWidth = MyConstraint.changeMultiplier(extraLevelsWidth, multiplier: 0.93)
            settingsWidth = MyConstraint.changeMultiplier(settingsWidth, multiplier: 0.93)
            creditsWidth = MyConstraint.changeMultiplier(creditsWidth, multiplier: 0.93)

        }
        
        let homeButtons: NSArray = [challengeButton,extraLevelsButton,settingsButton,creditsButton]
        for button in homeButtons{
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

