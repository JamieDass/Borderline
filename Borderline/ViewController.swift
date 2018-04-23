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
                item: constraint.firstItem!,
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
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func preferredContentSizeChanged(_ notification: Notification) {
        initButtons()
    }
    func initButtons(){
        let homeButtons: NSArray = [challengeButton,extraLevelsButton,settingsButton,aboutButton]
        for button in homeButtons as! [UIButton]{
            //        for button in homeButtons{
            styleButton(button: button, locked: false)
            button.addTarget(self, action: #selector(clickSound(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(touchButton(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpOutside)
        }
    }
    
    @objc func touchButton(_ sender : UIButton){
        let iframe = sender.frame
        let frame = CGRect(x: iframe.origin.x+5, y: iframe.origin.y+5, width: iframe.width, height: iframe.height)
        sender.layer.shadowOffset = CGSize(width:0.0,height:0.0)
        sender.frame = frame
    }
    @objc func releaseButton(_ sender : UIButton){
        let iframe = sender.frame
        let frame = CGRect(x: iframe.origin.x-5, y: iframe.origin.y-5, width: iframe.width, height: iframe.height)
        sender.layer.shadowOffset = CGSize(width:5.0,height:5.0)
        sender.frame = frame
    }
    
    @objc func clickSound(_ sender : UIButton){
        playClick()
    }
    
    func printFonts() {
        let families = UIFont.familyNames
        families.sorted().forEach {
            print("\($0)")
            let names = UIFont.fontNames(forFamilyName: $0)
            print(names)
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

