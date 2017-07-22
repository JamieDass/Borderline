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
import StoreKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var extraLevelsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var challengeWidth: NSLayoutConstraint!
    @IBOutlet weak var extraLevelsWidth: NSLayoutConstraint!
    @IBOutlet weak var settingsWidth: NSLayoutConstraint!
    @IBOutlet weak var aboutWidth: NSLayoutConstraint!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    @IBOutlet weak var backgroundImage: UIImageView!

    var products = [SKProduct]()
    
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
        loadProducts()
        self.updateScoreLabel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(UserDefaults.standard.dictionaryRepresentation())
//        self.printFonts()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.title = "Borderline"
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Images/Backgrounds/Pinstripes.png")!)
//        let homeConstraints: NSArray = [challengeWidth,extraLevelsWidth,settingsWidth,aboutWidth]
        initLevelCountries()

    let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad);
        if ( isiPad )
        {
            challengeWidth = MyConstraint.changeMultiplier(challengeWidth, multiplier: 0.85)
            extraLevelsWidth = MyConstraint.changeMultiplier(extraLevelsWidth, multiplier: 0.85)
            settingsWidth = MyConstraint.changeMultiplier(settingsWidth, multiplier: 0.85)
            aboutWidth = MyConstraint.changeMultiplier(aboutWidth, multiplier: 0.85)
        }else{
            challengeWidth = MyConstraint.changeMultiplier(challengeWidth, multiplier: 0.93)
            extraLevelsWidth = MyConstraint.changeMultiplier(extraLevelsWidth, multiplier: 0.93)
            settingsWidth = MyConstraint.changeMultiplier(settingsWidth, multiplier: 0.93)
            aboutWidth = MyConstraint.changeMultiplier(aboutWidth, multiplier: 0.93)

        }
        
        initButtons()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initButtons(){
        let homeButtons: NSArray = [challengeButton,extraLevelsButton,settingsButton,aboutButton]
        for button in homeButtons as! [UIButton]{
            //        for button in homeButtons{
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 0.0
            //            button.layer.backgroundColor = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0).cgColor
            button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
            //          button.layer.borderColor = UIColor.orange.cgColor
            button.layer.borderColor = GlobalConstants.darkBlue.cgColor
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            //            button.titleLabel?.textColor = UIColor.orange
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            button.addTarget(self, action: #selector(clickSound(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(touchButton(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpOutside)
            button.layer.shadowColor = GlobalConstants.shadowColour.cgColor
            button.layer.shadowRadius = 0
            button.layer.shadowOffset = CGSize(width:5.0,height:5.0)
            button.layer.masksToBounds = false
            button.layer.shadowOpacity = 1
        }
    }
    
    func touchButton(_ sender : UIButton){
        let iframe = sender.frame
        let frame = CGRect(x: iframe.origin.x+5, y: iframe.origin.y+5, width: iframe.width, height: iframe.height)
        sender.layer.shadowOffset = CGSize(width:0.0,height:0.0)
        sender.frame = frame
    }
    func releaseButton(_ sender : UIButton){
        let iframe = sender.frame
        let frame = CGRect(x: iframe.origin.x-5, y: iframe.origin.y-5, width: iframe.width, height: iframe.height)
        sender.layer.shadowOffset = CGSize(width:5.0,height:5.0)
        sender.frame = frame
    }
    
    func clickSound(_ sender : UIButton){
        playClick()
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    func loadProducts() {
        products = []
        BorderlineProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        print("segue")
        if let destination = segue.destination as? ExtraLevelsVC{
            destination.products = self.products
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

