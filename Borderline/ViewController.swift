//
//  ViewController.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-20.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class ViewController: UIViewController {
    
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var extraLevelsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var challengeWidth: NSLayoutConstraint!
    @IBOutlet weak var extraLevelsWidth: NSLayoutConstraint!
    @IBOutlet weak var settingsWidth: NSLayoutConstraint!
    @IBOutlet weak var creditsWidth: NSLayoutConstraint!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    struct MyConstraint {
        static func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
            let newConstraint = NSLayoutConstraint(
                item: constraint.firstItem,
                attribute: constraint.firstAttribute,
                relatedBy: constraint.relation,
                toItem: constraint.secondItem,
                attribute: constraint.secondAttribute,
                multiplier: multiplier,
                constant: constraint.constant)
            
            newConstraint.priority = constraint.priority
            
            NSLayoutConstraint.deactivate([constraint])
            NSLayoutConstraint.activate([newConstraint])
            
            return newConstraint
        }
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateScoreLabel(){
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateScoreLabel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.printFonts()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.title = "Borderline"
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Images/Backgrounds/Pinstripes.png")!)
//        let homeConstraints: NSArray = [challengeWidth,extraLevelsWidth,settingsWidth,creditsWidth]
        initLevelCountries()

    let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad);
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
            (button as AnyObject).layer.cornerRadius = 13
            (button as AnyObject).layer.borderWidth = 4.0
//            (button as AnyObject).layer.backgroundColor = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0).cgColor
            (button as AnyObject).layer.backgroundColor = GlobalConstants.darkBlue.cgColor
            //          (button as AnyObject).layer.borderColor = UIColor.orange.cgColor
            (button as AnyObject).layer.borderColor = GlobalConstants.darkBlue.cgColor
            (button as AnyObject).titleLabel??.numberOfLines = 1
            (button as AnyObject).titleLabel??.adjustsFontSizeToFitWidth = true
            (button as AnyObject).titleLabel??.lineBreakMode = NSLineBreakMode.byClipping
            (button as AnyObject).titleLabel??.textColor = UIColor.orange
            (button as AnyObject).titleLabel??.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            
            
//            button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }

    @IBAction func gameProgress(){
        let alert = SCLAlertView(appearance: progressApp(showCloseButton: true))
        showProgress(alert: alert)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}

