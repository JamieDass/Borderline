//
//  SettingsVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-13.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import AVFoundation

class SettingsVC: UIViewController {


    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.navigationItem.title = "Settings"
        self.configureButtons()
        // Do any additional setup after loading the view.
    }

    func configureButtons() {
        
        let defaults = UserDefaults.standard
        
        let buttons: NSArray = [soundButton,progressButton,rateButton,shareButton]
        for button in buttons as! [UIButton]{
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 0.0
            button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
            button.layer.borderColor = GlobalConstants.darkBlue.cgColor
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            button.addTarget(self, action: #selector(touchButton(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(releaseButton(_:)), for: .touchUpOutside)
            button.layer.shadowColor = GlobalConstants.shadowColour.cgColor
            button.layer.shadowRadius = 0
            button.layer.shadowOffset = CGSize(width:5.0,height:5.0)
            button.layer.masksToBounds = false
            button.layer.shadowOpacity = 1
            
            if (button == soundButton){
                if(defaults.bool(forKey: "sounds") == false){
                    button.backgroundColor = GlobalConstants.lightGrey
                    button.setTitleColor(GlobalConstants.darkBlue, for: UIControlState.normal)
                    button.setTitle("Turn Sounds On  🔇", for: UIControlState.normal)
                }
            }
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
    
    @IBAction func toggleSound(){
        let defaults = UserDefaults.standard
        if(defaults.bool(forKey: "sounds") == false){
            defaults.set(true, forKey: "sounds")
            playClick()
            soundButton.backgroundColor = GlobalConstants.darkBlue
            soundButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            soundButton.setTitle("Turn Sounds Off  🔈", for: UIControlState.normal)
        }else{
            defaults.set(false, forKey: "sounds")
            soundButton.backgroundColor = GlobalConstants.lightGrey
            soundButton.setTitleColor(GlobalConstants.darkBlue, for: UIControlState.normal)
            soundButton.setTitle("Turn Sounds On  🔇", for: UIControlState.normal)
        }
        
        
        
//        self.configureButtons()
        
    }
    
    @IBAction func resetProgressAlert(){
        playClick()
        let alertView = SCLAlertView()
        alertView.addButton("Reset"){
            self.resetProgress()
        }
        alertView.showTitle(
            "Are You Sure?", // Title of view
            subTitle: "This Will Reset Your Progress and Your Score", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .warning, // Styles - see below.
            colorStyle: 0xE96719,
            colorTextButton: 0xFFFFFF
        )
    }
    
    func resetProgress(){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "score")
        defaults.set(0, forKey: "levelLists")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Country")
        batchUpdateRequest.propertiesToUpdate = ["solved": 0, "regionRevealed": 0, "capitalRevealed": 0, "clueRevealed": 0, "flagRevealed": 0]
        
        
        
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        
        do{
            let objectIDs = try managedContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            let objects = objectIDs.result as! [NSManagedObjectID]
            
            objects.forEach({ objID in
                let managedObject = managedContext.object(with: objID)
                managedContext.refresh(managedObject, mergeChanges: false)
            })
        } catch {
        }
        initLevelCountries()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
