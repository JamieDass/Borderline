//
//  USStatesVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-24.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class USStatesVC: UIViewController {
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    fileprivate var countries:[Country] = []

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    @IBOutlet weak var level4Button: UIButton!
    @IBOutlet weak var level5Button: UIButton!
    
    @IBOutlet weak var progress1View: UIProgressView!
    @IBOutlet weak var progress2View: UIProgressView!
    @IBOutlet weak var progress3View: UIProgressView!
    @IBOutlet weak var progress4View: UIProgressView!
    @IBOutlet weak var progress5View: UIProgressView!
    
    @IBOutlet weak var progress1X: NSLayoutConstraint!
    @IBOutlet weak var progress2X: NSLayoutConstraint!
    @IBOutlet weak var progress3X: NSLayoutConstraint!
    @IBOutlet weak var progress4X: NSLayoutConstraint!
    @IBOutlet weak var progress5X: NSLayoutConstraint!

    
    
    @IBOutlet weak var l1Progress: UILabel!
    @IBOutlet weak var l2Progress: UILabel!
    @IBOutlet weak var l3Progress: UILabel!
    @IBOutlet weak var l4Progress: UILabel!
    @IBOutlet weak var l5Progress: UILabel!
    
    let levelStrings: NSArray = ["US States 1","US States 2","US States 3","US States 4","US States 5"]

    
    override func viewWillAppear(_ animated: Bool) {
        self.updateScoreLabel()
        self.configureButtons()
        self.lockLevels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.navigationItem.title = "US States"
//        self.configureButtons()
//        self.lockLevels()
        // Do any additional setup after loading the view.
    }
    
    
    func updateScoreLabel() {
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
        //        scoreBarItem.isEnabled = false
    }
    
    @IBAction func gameProgress(){
        //        showProgress()
        let alert = SCLAlertView(appearance: progressApp(showCloseButton: true))
        showProgress(alert: alert)
    }

    
    func lockLevels(){
        
        let lockLabels:NSArray = [l1Progress,l2Progress,l3Progress,l4Progress,l5Progress]
        
        let nSolved:Int = countries.count
        var thresholds: [Int:Int] = [0:-1,1:8,2:16,3:24,4:32,5:40]
        var idx:Int = 0
        for label in lockLabels{
            if(nSolved<thresholds[idx]!){
                (label as! UILabel).text = "🔒"
            }else{
                (label as! UILabel).text = ""
            }
            idx+=1
        }
    }

    
    func configureButtons() {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            let solvedNumber:NSNumber = 1
            let solvedPredicate = NSPredicate(format: "solved == %@", solvedNumber)
            let typePredicate = NSPredicate(format: "type == %@", "State")

            // predicate to find all solved countries. CoreData doesn't accept BOOLs so this is stored as NSNumber 0,1
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [typePredicate, solvedPredicate])

//            fetchRequest.predicate = NSPredicate(format: "solved == %@", solvedNumber)
            do {
                countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        let levelButtons: NSArray = [level1Button,level2Button,level3Button,level4Button,level5Button]
        let levelProgress: NSArray = [progress1View,progress2View,progress3View,progress4View,progress5View]
        let levelConstraints: NSArray = [progress1X,progress2X,progress3X,progress4X,progress5X]
        var index:Int = 0
        let nSolved:Int = countries.count
        var thresholds: [Int:Int] = [0:-1,1:8,2:16,3:24,4:32,5:40]

//        for (index, button) in levelButtons.enumerated() as! [UIButton]{
        for (idx, buttons) in levelButtons.enumerated(){
            let button = buttons as! UIButton
            //        for button in levelButtons{
            var locked:Bool = false
            if(nSolved<thresholds[index]!){
                locked = true
            }
            styleButton(button: button, locked: locked)
            button.addTarget(self, action: #selector(goToLevel(_:)), for: .touchUpInside)
            
            
            let bW = button.bounds.size.width/20
            let constraint:NSLayoutConstraint = levelConstraints.object(at: idx) as! NSLayoutConstraint
            constraint.constant = bW
            button.setInset(top: 0, left: bW, bottom: 0, right: 0)
            let progressView = levelProgress.object(at: index) as! UIProgressView
            progressView.tintColor = UIColor.white
            //                progressView.tintColor = GlobalConstants.darkBlue
            progressView.trackTintColor = UIColor.gray
            button.addSubview(progressView)
            index += 1
            let level:NSNumber = index as NSNumber
            let passedLevel = countries.filter{ $0.level == level }.count
            progressView.progress = Float(passedLevel)/Float(10)
        }
    }
    
    @objc func goToLevel(_ sender : UIButton) {
        //        AudioServicesPlaySystemSound(1306)
        let nSolved:Int = countries.count
        var thresholds: [Int:Int] = [0:-1,1:8,2:16,3:24,4:32,5:40]
        if (nSolved >= thresholds[sender.tag]!){
            playClick()
            //            AudioServicesPlaySystemSound(1306)
            self.performSegue(withIdentifier: "statesLevelSegue", sender: sender)
        }else{
            playSound(type: "Wrong")
            let diff:Int = thresholds[sender.tag]! - countries.count
            let diffString = "You Need to Solve "+String(diff)+" More States!"
            SCLAlertView().showError("Uh oh!", subTitle:diffString, closeButtonTitle: "Will Do!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LevelVC{
            destination.levelName = levelStrings[(sender! as AnyObject).tag] as! NSString
            destination.levelNumber = ((sender! as AnyObject).tag)+1 as NSNumber
            destination.levelType = "State"
        }
        
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
