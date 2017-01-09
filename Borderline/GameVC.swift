//
//  GameVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-28.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class GameVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - Class Variables
    
    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var clueButton: UIButton!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var imageX: NSLayoutConstraint!
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryGuess: UITextField!
    
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    
    let kContinentCost:Int = 1
    let kCapitalCost:Int = 2
    let kClueCost:Int = 3
    let kFlagCost:Int = 2
    let kRevealCost:Int = 15
    let kReward:Int = 3
    
    var clueTextViews: NSArray!
    var clueButtons: NSArray!
    
    var keyboardHeight: CGFloat = 0.0
    
    var clueTitle: String = "Clues"
    var clueSubTitle: String = "Need A Hint?"
    
    var cluesShown: Bool = false
    var flagShown: Bool = false
    
    var flagImage : UIImage!
    
    var countryNumber : NSNumber!
    var modified: Bool = false
    var alertVisible: Bool = false
    
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    var levelCountries: [String]!
    var countryList: [String] = ["Ireland", "Greece", "India", "Chile", "Italy", "The United Kingdom", "France", "Germany", "Russia", "Japan", "Mexico", "China", "Australia", "Canada", "USA",
                                 "Sweden", "Denmark", "Cyprus", "Norway", "South Africa", "Israel", "Vietnam", "Argentina", "Cuba", "New Zealand", "Spain", "Turkey", "Iceland", "Brazil", "Portugal",
                                 "North Korea", "Thailand", "Austria", "Uganda", "Netherlands", "South Korea", "Switzerland", "Hong Kong", "Belarus", "Poland", "Iran", "Costa Rica", "Belgium", "Egypt", "Kenya",
                                 "Indonesia", "Cambodia", "Mongolia", "Pakistan", "Bangladesh", "Colombia", "Malaysia", "Bhutan", "Jamaica", "Peru", "Nigeria", "Angola", "Singapore", "Algeria", "Libya",
                                 "Ghana", "Bosnia and Herzegovina", "Cameroon", "The Philippines", "Kazakhstan", "Slovenia", "Bolivia", "Azerbaijan", "Bulgaria", "Saudi Arabia", "Slovakia", "Taiwan", "Somalia", "Iraq", "Morocco",
                                 "Trinidad and Tobago", "Lebanon", "Estonia", "Czech Republic", "Ivory Coast", "Qatar", "Ecuador", "Croatia", "Isle of Man", "Hungary", "Ethiopia", "Paraguay", "Venezuela", "Tunisia", "Syria"]
    
    var levelCountryName : String!
    var levelCountryNumber : Int!
    var levelCountry : Country!
    var levelName = String()
    
    // MARK: - Initial Load
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize: CGRect = UIScreen.main.bounds
        //        imageBottom.constant = screenSize.height/2
        super.viewWillAppear(true)
        imageX.constant += screenSize.width*0.075
        self.updateScoreLabel()
        //        cluesShown = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Borderline"

        self.loadLevelCountries()
        self.loadCountry()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.1, animations: {self.viewBottom.constant = keyboardHeight})
            
        }
    }
    
    func loadLevelCountries(){
        let defaults = UserDefaults.standard
        levelCountries = defaults.object(forKey: levelName) as! [String]!
    }
    
    func updateScoreLabel(){
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
    }
    
    func loadCountry(){
        self.updateScoreLabel()
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
            do {
                let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                levelCountry = countries[0]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        let countryIdx: Int = countryList.index(of: levelCountryName)!
        levelCountryNumber = Int(ceilf(Float(countryIdx+1)/Float(GlobalConstants.countriesPerLevel)))
        
        self.view.backgroundColor = UIColor.orange
        
        
        self.countryGuess.delegate = self
        countryGuess.textColor = UIColor.orange
        countryGuess.text = ""
        let item : UITextInputAssistantItem = countryGuess.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        
        let revealBtnImage = UIImage(named: "Images/ClueRevealMed.png")! as UIImage
        revealButton.setImage(revealBtnImage, for: UIControlState.normal)
        
        let flagBtnImage = UIImage(named: "Images/ClueFlagMed.png")! as UIImage
        flagButton.setImage(flagBtnImage, for: UIControlState.normal)
        
        let clueBtnImage = UIImage(named: "Images/ClueMed.png")! as UIImage
        clueButton.setImage(clueBtnImage, for: UIControlState.normal)
        
        gameView.backgroundColor = GlobalConstants.defaultBlue
        bgView.backgroundColor = GlobalConstants.defaultBlue
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)        // Do any additional setup after loading the view.
        
        self.loadCountryView()
        if levelCountry.solved! == 1 {
            countryGuess.text = levelCountryName.uppercased()
            countryGuess.isEnabled = false
            clueButton.isHidden = true
            flagButton.isHidden = true
            revealButton.isHidden = true
        }else{
            countryGuess.isEnabled = true
            countryGuess.becomeFirstResponder()
            clueButton.isHidden = false
            flagButton.isHidden = false
            revealButton.isHidden = false
        }
        
    }
    
    func loadCountryView(){
        var flagType : String!
        var flagPath : String!
        if levelCountry.flagRevealed == 0 {
            flagType = "_mask.png"
            flagPath = "masks/"
        }else{
            flagType = "_clear.png"
            flagPath = "clear/"
        }
        
        var country: String = (levelCountry.name)!
        country = country.replacingOccurrences(of: " ", with: "_")
        country = country.appending(flagType)
        var path:String = "Images/Countries/"
        path = path.appending(flagPath)
        country = path.appending(country as String)
        flagImage = UIImage.init(named: country as String)
        gameImage.image = flagImage
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        self.checkAnswer()
        return true
    }
    
    // MARK: - Get Help
    
    @IBAction func showClues(){
        self.countryGuess.resignFirstResponder()
        self.cluesShown = true
        let appearance = SCLAlertView.SCLAppearance(
            kTextFont: UIFont(name: "HelveticaNeue", size: 20)!,
            showCloseButton: false,
            showCircularIcon: false,
            shouldAutoDismiss: false
        )
        let alertView = SCLAlertView(appearance:appearance)
        let alertViewResponder: SCLAlertViewResponder = alertView.showInfo(clueTitle, subTitle: clueSubTitle)
        
        var thisCountry : Country!
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
            do {
                let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                thisCountry = countries[0]
                
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
            var button1Title:String = "Reveal Continent (1★)"
            var button2Title:String = "Reveal Capital (2★)"
            var button3Title:String = "Reveal Clue (3★)"
            
            if thisCountry.continentRevealed == 1 {
                button1Title = "Show Continent"
            }
            if thisCountry.capitalRevealed == 1 {
                button2Title = "Show Capital"
            }
            if thisCountry.clueRevealed == 1 {
                button3Title = "Show Clue"
            }
            
            
            
            alertView.addButton(button1Title) {
                if thisCountry.continentRevealed == 0 {
                    if(getScore()<self.kContinentCost){
                        self.noStars()
                    }else{
//                        updateScore(increment: -self.kContinentCost)
//                        self.updateScoreLabel()
                        alertViewResponder.close()
                        self.showClueAlert(button: 1)
                    }
                }else{
                    alertViewResponder.setTitle("Continent:")
                    alertViewResponder.setSubTitle(thisCountry.continent!)
                }
            }
            alertView.addButton(button2Title) {
                if thisCountry.capitalRevealed == 0 {
                    if(getScore()<self.kCapitalCost){
                        self.noStars()
                    }else{
  //                      updateScore(increment: -self.kCapitalCost)
//                        self.updateScoreLabel()
                        alertViewResponder.close()
                        self.showClueAlert(button: 2)
                    }
                }else{
                    alertViewResponder.setTitle("Capital:")
                    alertViewResponder.setSubTitle(thisCountry.capital!)
                }
            }
            alertView.addButton(button3Title) {
                if thisCountry.clueRevealed == 0 {
                    if(getScore()<self.kClueCost){
                        self.noStars()
                    }else{
    //                    updateScore(increment: -self.kClueCost)
//                        self.updateScoreLabel()
                        alertViewResponder.close()
                        self.showClueAlert(button: 3)
                    }
                }else{
                    alertViewResponder.setTitle("Name:")
                    alertViewResponder.setSubTitle(thisCountry.clue!)
                }
            }
            alertView.addButton("Back") {
                alertViewResponder.close()
                self.cluesShown = false
                self.clueTitle = "Clues"
                self.clueSubTitle = "Need A Hint?"
                self.countryGuess.becomeFirstResponder()
            }
            
            alertView.showInfo(clueTitle, subTitle: clueSubTitle)
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to save record")
                print(error)
                
                // Do something in response to error condition
            }
        }
    }
    
    func showClueAlert(button: Int) {
        var thisCountry : Country!
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
            do {
                let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                thisCountry = countries[0]
                
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
            
            var title = String()
            var subTitle = String()
            switch button {
            case 1:
                title = "Reveal Continent?"
                subTitle = "Cost: "+String(self.kContinentCost)+"★"
            case 2:
                title = "Reveal Capital?"
                subTitle = "Cost: "+String(self.kCapitalCost)+"★"
            case 3:
                title = "Reveal Clue?"
                subTitle = "Cost: "+String(self.kClueCost)+"★"
            default:
                print("")
            }
            
            let subAppearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let subAlertView = SCLAlertView(appearance: subAppearance)
            subAlertView.addButton("OK") {
                switch button {
                case 1:
                    updateScore(increment: -self.kContinentCost)
                    thisCountry.continentRevealed = 1
                    self.clueTitle = "Continent:"
                    self.clueSubTitle = thisCountry.continent!
                case 2:
                    updateScore(increment: -self.kCapitalCost)
                    thisCountry.capitalRevealed = 1
                    self.clueTitle = "Capital:"
                    self.clueSubTitle = thisCountry.capital!
                case 3:
                    updateScore(increment: -self.kClueCost)
                    thisCountry.clueRevealed = 1
                    self.clueTitle = "Name:"
                    var countryName: String = thisCountry.clue!.replacingOccurrences(of: " ", with: "\n")
                    countryName = self.insert(separator: " ", afterEveryXChars: 1, intoString: countryName)
//                    let countryName:String = self.insert(separator: "\u{00a0}", afterEveryXChars: 1, intoString: thisCountry.clue!)
                    self.clueSubTitle = countryName
                default:
                    print("nothing")
                }
                self.updateScoreLabel()
                self.showClues()
                //                self.countryGuess.becomeFirstResponder()
            }
            subAlertView.addButton("Cancel") {
                self.showClues()
            }
            subAlertView.showInfo(title, subTitle: subTitle, animationStyle:.leftToRight)
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to save record")
                print(error)
                
                // Do something in response to error condition
            }
        }
        
    }
    
    @IBAction func showFlagAlert(){
        if levelCountry.flagRevealed == 0 {
            self.sclAlert(showCloseButton: false, title: "Reveal Flag?", subtitle: "2★", closeText: "Cancel", style: .warning, alertContext: "revealFlag")
        }
    }
    
    func revealFlag(){
        if(getScore()<self.kFlagCost){
            self.noStars()
        }else{
            updateScore(increment: -self.kFlagCost)
            self.updateScoreLabel()
            var thisCountry : Country!
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
                fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
                do {
                    let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                    thisCountry = countries[0]
                    //                print(thisCountry.objectID)
                } catch {
                    print("Failed to retrieve record")
                    print(error)
                }
                //        }
                
                if levelCountry.flagRevealed == 0 {
                    thisCountry.flagRevealed = 1
                    levelCountry.flagRevealed = 1
                    modified = true
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("Failed to save record")
                        print(error)
                        
                        // Do something in response to error condition
                    }
                    
                    self.loadCountryView()
                }
            }
            self.countryGuess.becomeFirstResponder()
        }
    }
    
    @IBAction func revealAnswerAlert() {
        if levelCountry.solved == 0 {
            
            self.sclAlert(showCloseButton: false, title: "Reveal Answer?", subtitle: "15★", closeText: "Cancel", style: .info, alertContext: "revealAnswer")
            
            //            let alertController = UIAlertController(title: "Reveal Answer?", message: "10★", preferredStyle: .alert)
            //
            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //                // ...
            //            }
            //            alertController.addAction(cancelAction)
            //
            //            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //                self.revealAnswer()
            //                // ...
            //            }
            //            alertController.addAction(OKAction)
            //
            //            self.present(alertController, animated: true) {
            //                // ...
            //            }
            
        }
        
    }
    
    func revealAnswer(){
        
        if(getScore()<self.kRevealCost){
            self.noStars()
        }else{
            updateScore(increment: -self.kRevealCost)
            
            countryGuess.text = levelCountryName.uppercased()
            countryGuess.resignFirstResponder()
            
            var thisCountry : Country!
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
                fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
                do {
                    let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                    thisCountry = countries[0]
                    //                print(thisCountry.objectID)
                } catch {
                    print("Failed to retrieve record")
                    print(error)
                }
                //        }
                
                thisCountry.flagRevealed = 1
                thisCountry.solved = 1
                levelCountry.flagRevealed = 1
                levelCountry.solved = 1
                clueButton.isHidden = true
                flagButton.isHidden = true
                revealButton.isHidden = true
                modified = true
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Failed to save record")
                    print(error)
                    
                    // Do something in response to error condition
                }
                self.updateScoreLabel()
                self.loadCountryView()
                
            }
        }
        
    } // function
    
    
    //MARK: - Check Answer
    
    
    @IBAction func checkAnswer(){
        var allAnswers = levelCountry.answers
        allAnswers = allAnswers?.lowercased()
        
        let arrAnswers = allAnswers?.components(separatedBy: ", ")
        var answerCheck:String = countryGuess.text!
        answerCheck = answerCheck.lowercased()
        answerCheck = answerCheck.replacingOccurrences(of: "the ", with: "")
        if (arrAnswers?.contains(answerCheck))! {
            self.rightAnswer()
        }else{
            self.sclAlert(showCloseButton: false, title: "Uh Oh!", subtitle: "Wrong Answer", closeText: "D'oh!", style: .error,  alertContext: "")
        }
        
    }
    
    func rightAnswer(){
        
//        updateScore(increment: self.kReward)
        
        countryGuess.resignFirstResponder()
        
        var thisCountry : Country!
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "name == %@", levelCountryName)
            do {
                let countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
                thisCountry = countries[0]
                //                print(thisCountry.objectID)
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
            //        }
            
            thisCountry.flagRevealed = 1
            thisCountry.solved = 1
            levelCountry.flagRevealed = 1
            levelCountry.solved = 1
            clueButton.isHidden = true
            flagButton.isHidden = true
            revealButton.isHidden = true
            modified = true
            do {
                try managedObjectContext.save()
            } catch {
                print("Failed to save record")
                print(error)
                
                // Do something in response to error condition
            }
            self.loadCountryView()
            updateScore(increment: self.kReward)
        }
        
        self.nextLevel()
//        let thisCountryIdx = countryList.index(of: levelCountryName)
//        let modCompare = thisCountryIdx!+1
//        if(modCompare % GlobalConstants.countriesPerLevel != 0){
////            self.nextLevel()
//            let nextCountry = countryList[thisCountryIdx!+1]
//            levelCountryName = nextCountry
//            
//            let appearance = SCLAlertView.SCLAppearance(
//                showCloseButton: false
//            )
//            let alertView = SCLAlertView(appearance: appearance)
//            alertView.addButton("Next") {
//                self.loadCountry()
//            }
//            alertView.addButton("Back") {
//                if let navController = self.navigationController {
//                    navController.popViewController(animated: true)
//                }
//                self.countryGuess.resignFirstResponder()
//            }
//            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: "+String(self.kReward)+"★")
//            
//            
//        }else{
//            
//            let appearance = SCLAlertView.SCLAppearance(
//                showCloseButton: false
//            )
//            let alertView = SCLAlertView(appearance: appearance)
//            alertView.addButton("OK") {
//                if let navController = self.navigationController {
//                    navController.popViewController(animated: true)
//                }
//                self.countryGuess.resignFirstResponder()
//                
//            }
//            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: "+String(self.kReward)+"★")
//        }
        modified = true
        
    }
    
    func nextLevel(){

        let thisCountryIdx = levelCountries.index(of: levelCountryName)
        let modCompare = thisCountryIdx!+1
        levelCountries.remove(at: thisCountryIdx!)
        let defaults = UserDefaults.standard
        defaults.set(levelCountries, forKey:levelName)
        
        

//        initLevelCountries()

//        self.loadLevelCountries()
//        print(levelCountries)
//        self.loadLevelCountries()
        if(levelCountries.count != 0){ // if there are more countries to complete in this level
            var nextIdx:Int = thisCountryIdx!
            if(modCompare > levelCountries.count){
                nextIdx = 0
            }
            let nextCountry = levelCountries[nextIdx]
//            let nextCountry = countryList[nextIdx]
            levelCountryName = nextCountry
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Next") {
                self.loadCountry()
            }
            alertView.addButton("Back") {
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                self.countryGuess.resignFirstResponder()
            }
            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: "+String(self.kReward)+"★")
            
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                self.countryGuess.resignFirstResponder()
                
            }
            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: "+String(self.kReward)+"★")
        }

    }
    
    @IBAction func exitGame(){
        countryGuess.resignFirstResponder()
    }
    
    
    //Mark - Utilities
    
    
    func noStars(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Will Do!") {
            if(!self.cluesShown){
                self.countryGuess.becomeFirstResponder()
            }
        }
        alertView.showError("Uh Oh!", subTitle: "You Need to Earn More Stars")
        //        SCLAlertView().showError("Uh Oh!", subTitle: "You Need to Earn More Stars",closeButtonTitle: "Will Do!")
    }
    
    func sclAlert(showCloseButton: Bool, title: String, subtitle: String, closeText: String, style: SCLAlertViewStyle, alertContext: String){
        
        var defaultColorInt: UInt {
            switch style {
            case .success:
                return 0x22B573
            case .error:
                return 0xC1272D
            case .notice:
                return 0x727375
            case .warning:
                return 0xFFD110
            case .info:
                return 0x2866BF
            case .edit:
                return 0xA429FF
            case .wait:
                return 0xD62DA5
            }
            
        }
        
        var colorInt: UInt = defaultColorInt
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton:showCloseButton
        )
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        
        self.drawWarning()
        let warningImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let iconImage: UIImage = warningImage
        
        
        let alertView = SCLAlertView(appearance: appearance)
        if(alertContext != ""){
            var selector = String()
            var buttonTitle = String()
            
            switch alertContext {
            case "revealFlag":
                selector = "revealFlag"
                buttonTitle = "Reveal"
                colorInt = 0x2866BF
            case "rightAnswer":
                selector = "loadCountry"
                buttonTitle = "Next"
                colorInt = 0x22B573
            case "revealAnswer":
                selector = "revealAnswer"
                buttonTitle = "Reveal"
                colorInt = 0xA429FF
            default: selector = ""
            }
            alertView.addButton(buttonTitle, target:self, selector:Selector(selector))
        }
        alertView.addButton(closeText){
            self.countryGuess.becomeFirstResponder()
        }
        
        
        //        var alertViewIcon = UIImage()
        //        if(customIcon != ""){
        //            alertViewIcon = UIImage(named: customIcon)!
        //        }
        countryGuess.resignFirstResponder()
        alertView.showTitle(
            title, // Title of view
            subTitle: subtitle, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: closeText, // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: colorInt,
            colorTextButton: 0xFFFFFF,
            circleIconImage: iconImage
        )
    }
    
    func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()
        crossShapePath.move(to: CGPoint(x: 10, y: 70))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 10))
        crossShapePath.move(to: CGPoint(x: 10, y: 10))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 70))
        crossShapePath.lineCapStyle = CGLineCap.round;
        crossShapePath.lineJoinStyle = CGLineJoin.round;
        UIColor.white.setStroke()
        crossShapePath.lineWidth = 14
        crossShapePath.stroke()
    }
    
    func drawWarning() {
        // Color Declarations
        //        let greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.000)
        
        // Warning Group
        // Warning Circle Drawing
        let warningCirclePath = UIBezierPath()
        warningCirclePath.move(to: CGPoint(x: 40.94, y: 63.39))
        warningCirclePath.addCurve(to: CGPoint(x: 36.03, y: 65.55), controlPoint1: CGPoint(x: 39.06, y: 63.39), controlPoint2: CGPoint(x: 37.36, y: 64.18))
        warningCirclePath.addCurve(to: CGPoint(x: 34.14, y: 70.45), controlPoint1: CGPoint(x: 34.9, y: 66.92), controlPoint2: CGPoint(x: 34.14, y: 68.49))
        warningCirclePath.addCurve(to: CGPoint(x: 36.22, y: 75.54), controlPoint1: CGPoint(x: 34.14, y: 72.41), controlPoint2: CGPoint(x: 34.9, y: 74.17))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 77.5), controlPoint1: CGPoint(x: 37.54, y: 76.91), controlPoint2: CGPoint(x: 39.06, y: 77.5))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 75.35), controlPoint1: CGPoint(x: 42.83, y: 77.5), controlPoint2: CGPoint(x: 44.53, y: 76.72))
        warningCirclePath.addCurve(to: CGPoint(x: 47.93, y: 70.45), controlPoint1: CGPoint(x: 47.18, y: 74.17), controlPoint2: CGPoint(x: 47.93, y: 72.41))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 65.35), controlPoint1: CGPoint(x: 47.93, y: 68.49), controlPoint2: CGPoint(x: 47.18, y: 66.72))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 63.39), controlPoint1: CGPoint(x: 44.53, y: 64.18), controlPoint2: CGPoint(x: 42.83, y: 63.39))
        warningCirclePath.close()
        warningCirclePath.miterLimit = 4;
        
        UIColor.white.setFill()
        warningCirclePath.fill()
        
        
        // Warning Shape Drawing
        let warningShapePath = UIBezierPath()
        warningShapePath.move(to: CGPoint(x: 46.23, y: 4.26))
        warningShapePath.addCurve(to: CGPoint(x: 40.94, y: 2.5), controlPoint1: CGPoint(x: 44.91, y: 3.09), controlPoint2: CGPoint(x: 43.02, y: 2.5))
        warningShapePath.addCurve(to: CGPoint(x: 34.71, y: 4.26), controlPoint1: CGPoint(x: 38.68, y: 2.5), controlPoint2: CGPoint(x: 36.03, y: 3.09))
        warningShapePath.addCurve(to: CGPoint(x: 31.5, y: 8.77), controlPoint1: CGPoint(x: 33.01, y: 5.44), controlPoint2: CGPoint(x: 31.5, y: 7.01))
        warningShapePath.addLine(to: CGPoint(x: 31.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 34.71, y: 54.44))
        warningShapePath.addCurve(to: CGPoint(x: 40.38, y: 58.16), controlPoint1: CGPoint(x: 34.9, y: 56.2), controlPoint2: CGPoint(x: 36.41, y: 58.16))
        warningShapePath.addCurve(to: CGPoint(x: 45.67, y: 54.44), controlPoint1: CGPoint(x: 44.34, y: 58.16), controlPoint2: CGPoint(x: 45.67, y: 56.01))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 8.77))
        warningShapePath.addCurve(to: CGPoint(x: 46.23, y: 4.26), controlPoint1: CGPoint(x: 48.5, y: 7.01), controlPoint2: CGPoint(x: 47.74, y: 5.44))
        warningShapePath.close()
        warningShapePath.miterLimit = 4;
        
        UIColor.white.setFill()
        warningShapePath.fill()
    }
    
    func insert(separator: String, afterEveryXChars: Int, intoString: String) -> String {
        var output = ""
        intoString.characters.enumerated().forEach { index, c in
            if index % afterEveryXChars == 0 && index > 0 {
                output += separator
            }
            output.append(c)
        }
        return output
    }
    
    
}
