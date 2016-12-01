//
//  ChallengeVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-21.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData

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

    
    
    @IBOutlet weak var scoreLab: UILabel!
    let levelStrings: NSArray = ["Level 1","Level 2","Level 3","Level 4","Level 5","Level 6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(7, forKey: "score")
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            // predicate to find all solved countries. CoreData doesn't accept BOOLs so this is stored as NSNumber 0,1
            fetchRequest.predicate = NSPredicate(format: "solved == %@", 0)
            do {
                countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        self.navigationItem.title = "Challenge"
        let levelButtons: NSArray = [level1Button,level2Button,level3Button,level4Button,level5Button,level6Button]
        let levelProgress: NSArray = [progress1View,progress2View,progress3View,progress4View,progress5View,progress6View]
        let levelConstraints: NSArray = [progress1X,progress2X,progress3X,progress4X,progress5X,progress6X]
        var index:Int = 0
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
//            let edgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
            let bW = (button as AnyObject).bounds.size.width/20
            let constraint:NSLayoutConstraint = levelConstraints.object(at: index) as! NSLayoutConstraint
            constraint.constant = bW
            (button as! UIButton).setInset(top: 0, left: bW, bottom: 0, right: 0)
            let progressView = levelProgress.object(at: index) as! UIProgressView
            progressView.tintColor = UIColor.white
            progressView.trackTintColor = UIColor.gray
//            progressView.trackTintColor = UIColor(red: 28/255, green: 86/255, blue: 133/255, alpha: 1.0)
            
//            progressView.progress = (1/Float(index+1))
//            progressView.frame.offsetBy(dx: 100,dy: 0)
            (button as AnyObject).addSubview(progressView)
            index += 1
            let level:NSNumber = index as NSNumber
            let passedLevel = countries.filter{ $0.level == level }.count
            progressView.progress = Float(passedLevel)/12.0

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        LevelVC *targetVC = segue.destinationViewController
        if let destination = segue.destination as? LevelVC{
            destination.levelName = levelStrings[(sender! as AnyObject).tag] as! NSString
//            let target: NSNumber = (sender! as AnyObject).tag as NSNumber
            destination.levelNumber = ((sender! as AnyObject).tag)+1 as NSNumber
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
