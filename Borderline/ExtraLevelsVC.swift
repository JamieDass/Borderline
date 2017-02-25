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
        if(self.products.count == 0){
            loadProducts()
        }
        self.updateScoreLabel()
//        self.configureButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        products = loadProducts()
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
                if (BorderlineProducts.store.isProductPurchased("co.jetliner.borderline.usstates")){
                    button.setTitle("US States", for: UIControlState.normal)
                }else{
                    button.setTitle("US States 🔒🛒", for: UIControlState.normal)
                }
                
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
            if(self.products.count > 0){
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 18)!
                )

                let alert = SCLAlertView(appearance: appearance)
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = NSLocale.current
                var title: String = "Unlock US States?"
                var closeText: String = "No Thanks!"
                var subTitle: String = "\nMastered the countries of the world?\nTry your hand at the United States.\n\n"+formatter.string(from: self.products[0].price)!
                if(IAPHelper.canMakePayments()){
                    alert.addButton("Buy"){
                        BorderlineProducts.store.buyProduct(self.products[0])
                        NotificationCenter.default.addObserver(self, selector: #selector(ExtraLevelsVC.purchaseSucceeded), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
                    }
                    alert.addButton("Restore Purchases"){
                        BorderlineProducts.store.restorePurchases()
                         NotificationCenter.default.addObserver(self, selector: #selector(ExtraLevelsVC.restoreSucceeded), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
                    }

                }else{
                    title = "Purchases Disabled"
                    subTitle = "You must be authorised to make payments to proceed."
                    closeText = "OK!"
                }
                alert.showInfo(title, subTitle: subTitle,closeButtonTitle: closeText)
            }
        }// else
 

    }

    func purchaseSucceeded(sender : UIButton) {
        print("purchased!")
        self.configureButtons()
        self.performSegue(withIdentifier: "statesSegue", sender: sender)
    }
    
    func restoreSucceeded(sender : UIButton) {
        self.configureButtons()
        SCLAlertView().showSuccess(
            "Success!", // Title of view
            subTitle: "Purchase Restored.", // String of view
            closeButtonTitle: "Cool!",
            duration: 2.0 // Duration to show before closing automatically, default: 0.0
        )
        self.performSegue(withIdentifier: "statesSegue", sender: sender)
        
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
        if let destination = segue.destination as? LevelVC{
            destination.levelName = "Former Countries"
            destination.levelNumber = 1
            destination.levelType = "FormerCountry"
        }
//        print("segue 2")
    }
    
    
}
