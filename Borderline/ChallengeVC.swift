//
//  ChallengeVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-21.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class ChallengeVC: UIViewController {
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    fileprivate var countries:[Country] = []
    
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    @IBOutlet weak var level4Button: UIButton!
    @IBOutlet weak var level5Button: UIButton!
    @IBOutlet weak var level6Button: UIButton!
    @IBOutlet weak var progress1View: UIProgressView!
    @IBOutlet weak var progress2View: UIProgressView!
    @IBOutlet weak var progress3View: UIProgressView!
    @IBOutlet weak var progress4View: UIProgressView!
    @IBOutlet weak var progress5View: UIProgressView!
    @IBOutlet weak var progress6View: UIProgressView!
    @IBOutlet weak var progress1X: NSLayoutConstraint!
    @IBOutlet weak var progress2X: NSLayoutConstraint!
    @IBOutlet weak var progress3X: NSLayoutConstraint!
    @IBOutlet weak var progress4X: NSLayoutConstraint!
    @IBOutlet weak var progress5X: NSLayoutConstraint!
    @IBOutlet weak var progress6X: NSLayoutConstraint!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!

    @IBOutlet weak var l1Progress: UILabel!
    @IBOutlet weak var l2Progress: UILabel!
    @IBOutlet weak var l3Progress: UILabel!
    @IBOutlet weak var l4Progress: UILabel!
    @IBOutlet weak var l5Progress: UILabel!
    @IBOutlet weak var l6Progress: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
//    private var lockLabels = [UILabel]()
    
    @IBOutlet weak var scoreLab: UILabel!
    let levelStrings: NSArray = ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]

    override func viewWillAppear(_ animated: Bool) {
        self.updateScoreLabel()
        self.configureButtons()
        self.lockLevels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.navigationItem.title = "Challenge"
//        self.configureButtons()
        
//        self.lockLevels()
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

        let lockLabels:NSArray = [l1Progress,l2Progress,l3Progress,l4Progress,l5Progress,l6Progress]
        
        let nSolved:Int = countries.count
        var thresholds: [Int:Int] = [0:-1,1:10,2:20,3:30,4:40,5:50]
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
            // predicate to find all solved countries. CoreData doesn't accept BOOLs so this is stored as NSNumber 0,1
            let solvedNumber:NSNumber = 1
            let solvedPredicate = NSPredicate(format: "solved == %@", solvedNumber)
            let typePredicate = NSPredicate(format: "type == %@", "Country")
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [typePredicate, solvedPredicate])
            do {
                countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        let levelButtons: NSArray = [level1Button,level2Button,level3Button,level4Button,level5Button,level6Button]
        let levelProgress: NSArray = [progress1View,progress2View,progress3View,progress4View,progress5View,progress6View]
        let levelConstraints: NSArray = [progress1X,progress2X,progress3X,progress4X,progress5X,progress6X]
        var index:Int = 0
        for button in levelButtons as! [UIButton]{
//        for button in levelButtons{
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 4.0
//            button.layer.backgroundColor = UIColor(red: 11/255, green: 24/255, blue: 37/255, alpha: 1.0).cgColor
               button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
  //          button.layer.borderColor = UIColor.orange.cgColor
              button.layer.borderColor = GlobalConstants.darkBlue.cgColor
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            button.titleLabel?.textColor = UIColor.orange
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            button.addTarget(self, action: #selector(goToLevel(_:)), for: .touchUpInside)
//            (button as! UIButton).addTarget(self, action: #selector(goToLevel(_:)), for: .touchUpInside)
            
            //            let edgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
            let bW = button.bounds.size.width/20
            let constraint:NSLayoutConstraint = levelConstraints.object(at: index) as! NSLayoutConstraint
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
            progressView.progress = Float(passedLevel)/Float(GlobalConstants.countriesPerLevel)
        }
    }
    
    func goToLevel(_ sender : UIButton) {
//        AudioServicesPlaySystemSound(1306)
        let nSolved:Int = countries.count
        var thresholds: [Int:Int] = [0:-1,1:10,2:20,3:30,4:40,5:50]
        if (nSolved >= thresholds[sender.tag]!){
            playClick()
//            AudioServicesPlaySystemSound(1306)
            self.performSegue(withIdentifier: "levelSegue", sender: sender)
        }else{
            playSound(type: "Wrong")
            let diff:Int = thresholds[sender.tag]! - countries.count
            let diffString = "You Need to Solve "+String(diff)+" More Countries!"
            SCLAlertView().showError("Uh oh!", subTitle:diffString, closeButtonTitle: "Will Do!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LevelVC{
            destination.levelName = levelStrings[(sender! as AnyObject).tag] as! NSString
            destination.levelNumber = ((sender! as AnyObject).tag)+1 as NSNumber
            destination.levelType = "Country"
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
