//
//  ExtraLevelsVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-24.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import SCLAlertView
import StoreKit

class ExtraLevelsVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usStatesButton: UIButton!
    @IBOutlet weak var formerCountriesButton: UIButton!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    
    var products = [SKProduct]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateScoreLabel()
        self.configureButtons()
        loadProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.configureButtons()
        self.navigationItem.title = "Extra Levels"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureButtons() {
        let extraLevelButtons: NSArray = [usStatesButton,formerCountriesButton]
        
        for (idx,buttons) in extraLevelButtons.enumerated(){
            let button = buttons as! UIButton
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 4.0
            button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
            button.layer.borderColor = GlobalConstants.darkBlue.cgColor
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            if(idx == 0){
                button.addTarget(self, action: #selector(goToStates(_:)), for: .touchUpInside)
            }
        }
    }
    
    func updateScoreLabel() {
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
    }

    @IBAction func gameProgress(){
        let alert = SCLAlertView(appearance: progressApp(showCloseButton: true))
        showProgress(alert: alert)
    }

    // MARK: - Navigation

    func goToStates(_ sender : UIButton) {
        if BorderlineProducts.store.isProductPurchased(BorderlineProducts.USStates) {
            self.performSegue(withIdentifier: "statesSegue", sender: sender)
        }else{
            let alert = SCLAlertView()
            alert.addButton("Proceed"){
                BorderlineProducts.store.buyProduct(self.products[0])
            }
            alert.showInfo("Unlock US States?", subTitle: "Extra Levels!\nAll 50 US States.\nHave you mastered the countries of the world?\nTry your hand at the United States.\nThis is a tough one…",closeButtonTitle: "No Thanks!")
//        alert.showInfo(progress, subTitle: levelProgress,closeButtonTitle: "Cool!")
        }

    }
    
    func loadProducts() {
        products = []
        
        BorderlineProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
        print(self.products)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("segue")
        if let destination = segue.destination as? LevelVC{
            destination.levelName = "Former Countries"
            destination.levelNumber = 1
            destination.levelType = "FormerCountry"
        }
//        print("segue 2")
    }
    
    
}
