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

    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var clueButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var imageX: NSLayoutConstraint!
    
//    @IBOutlet weak var countryGuessConstraint: NSLayoutConstraint!
    @IBOutlet weak var clueView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryGuess: UITextField!
    
    @IBOutlet weak var clue1: UITextView!
    @IBOutlet weak var clue2: UITextView!
    @IBOutlet weak var clue3: UITextView!
    
    
    
    @IBOutlet weak var clue1Button: UIButton!
    @IBOutlet weak var clue2Button: UIButton!
    @IBOutlet weak var clue3Button: UIButton!
    

    
    var clueTextViews: NSArray!
    var clueButtons: NSArray!
    
    var keyboardHeight: CGFloat = 0.0
    
//    var cluesShown = Bool()
    var clueTitle: String = "Clues"
    var clueSubTitle: String = "Need A Hint?"
    
    var cluesShown: Bool = false
    var flagShown: Bool = false
    
    var flagImage : UIImage!
    
    var countryNumber : NSNumber!
    var modified: Bool = false
    var alertVisible: Bool = false
    
    
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    
    var countryList: [String] = ["Italy", "China", "Canada", "Australia", "France", "Germany", "Greece", "India", "Japan", "Mexico", "USA", "The United Kingdom", "Argentina", "Brazil", "Cyprus", "Ireland", "New Zealand", "Russia", "Portugal", "Spain", "South Africa", "Norway", "Vietnam", "Chile", "Austria", "Belgium", "Cuba", "North Korea", "Denmark", "Egypt", "Sweden", "Iceland", "Iran", "Turkey", "Netherlands", "Poland", "Switzerland", "South Korea", "Singapore", "Kenya", "Libya", "Malaysia", "Algeria", "Thailand", "Indonesia", "Nigeria", "Peru", "Pakistan", "Somalia", "Morocco", "Taiwan", "Kazakhstan", "Cameroon", "Bulgaria", "Colombia", "The Philippines", "Iraq", "Jamaica", "Bolivia", "Saudi Arabia", "Ecuador", "Croatia", "Czech Republic", "Lebanon", "Paraguay", "Syria", "Hungary", "Ivory Coast", "Trinidad and Tobago", "Tunisia", "Venezuela", "Isle of Man"]

    var levelCountryName : String!
    var levelCountryNumber : Int!
    var levelCountry : Country!

    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize: CGRect = UIScreen.main.bounds
//        imageBottom.constant = screenSize.height/2
        super.viewWillAppear(true)
        imageX.constant += screenSize.width*0.075
        clueView.isHidden = true

//        cluesShown = false
        
         // Do any additional setup after loading the view.
    }
    
    

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height

            UIView.animate(withDuration: 0.1, animations: {self.viewBottom.constant = keyboardHeight})
            

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCountry()
        
    }
    
    func loadCountry(){
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
        levelCountryNumber = Int(ceilf(Float(countryIdx+1)/12.0))
        
        self.view.backgroundColor = UIColor.orange
        clueTextViews = [clue1,clue2,clue3]
        clueButtons = [clue1Button,clue2Button,clue3Button]
        
        
        clueView.backgroundColor = GlobalConstants.defaultBlue
        clueView.layer.borderColor = UIColor.orange.cgColor
        clueView.layer.cornerRadius = 10
        clueView.layer.borderWidth = 4.0
        self.countryGuess.delegate = self
        countryGuess.textColor = UIColor.orange
        countryGuess.text = ""
        let item : UITextInputAssistantItem = countryGuess.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        
        let image = UIImage(named: "Images/CloseButtonMed.png")! as UIImage
        closeButton.setImage(image, for: UIControlState.normal)
        
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
        self.configureClues()
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
//    func textFieldDidEndEditing(_ textField: UITextField) -> Bool
    {
//        countryGuess.resignFirstResponder()
        self.checkAnswer()
        return true
    }
    
    
    
     @IBAction func showClues(){
        self.countryGuess.resignFirstResponder()
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
            var button1Title:String = "Reveal Clue 1 (1★)"
            var button2Title:String = "Reveal Clue 2 (2★)"
            var button3Title:String = "Reveal Clue 3 (3★)"
            
            if thisCountry.capitalRevealed == 1 {
                button1Title = "Show Capital"
            }
            if thisCountry.continentRevealed == 1 {
                button2Title = "Show Continent"
            }
            if thisCountry.clueRevealed == 1 {
                button3Title = "Show Clue"
            }
            
            alertView.addButton(button1Title) {
                if thisCountry.capitalRevealed == 0 {
                    alertViewResponder.close()
                    self.showClueAlert(button: 1)
                }else{
                    alertViewResponder.setTitle("Capital:")
                    alertViewResponder.setSubTitle(thisCountry.capital!)
                }
            }
            
            alertView.addButton(button2Title) {
                if thisCountry.continentRevealed == 0 {
                    alertViewResponder.close()
                    self.showClueAlert(button: 2)
                }else{
                    alertViewResponder.setTitle("Continent:")
                    alertViewResponder.setSubTitle(thisCountry.continent!)
                }
            }
            alertView.addButton(button3Title) {
                if thisCountry.clueRevealed == 0 {
                    alertViewResponder.close()
                    self.showClueAlert(button: 3)
                }else{
                    alertViewResponder.setTitle("Name:")
                    alertViewResponder.setSubTitle(thisCountry.clue!)
                }
            }
            alertView.addButton("Back") {
                alertViewResponder.close()
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
//        if !cluesShown {
//            flagButton.isHidden = true
//            revealButton.isHidden = true
//            clueView.isHidden = false
//            cluesShown = true
//        }else{
//            flagButton.isHidden = false
//            revealButton.isHidden = false
//            clueView.isHidden = true
//            cluesShown = false
//        }
//        
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
                title = "Reveal Capital?"
                subTitle = "Cost: 1★"
            case 2:
                title = "Reveal Continent?"
                subTitle = "Cost: 2★"
            case 3:
                title = "Reveal Clue?"
                subTitle = "Cost: 3★"
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
                    thisCountry.capitalRevealed = 1
                    self.clueTitle = "Capital:"
                    self.clueSubTitle = thisCountry.capital!
                case 2:
                    thisCountry.continentRevealed = 1
                    self.clueTitle = "Continent:"
                    self.clueSubTitle = thisCountry.continent!
                case 3:
                    thisCountry.clueRevealed = 1
                    self.clueTitle = "Name:"
                    self.clueSubTitle = thisCountry.clue!
                default:
                    print("nothing")
                }
                self.showClues()
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
            self.sclAlert(showCloseButton: true, title: "Reveal Flag?", subtitle: "3★", closeText: "Cancel", style: .warning, alertContext: "revealFlag")
        }
    }
    
    func revealFlag(){
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
    }
    
     @IBAction func checkAnswer(){
        var allAnswers = levelCountry.answers
        allAnswers = allAnswers?.lowercased()
        
        let arrAnswers = allAnswers?.components(separatedBy: ", ")
        var answerCheck:String = countryGuess.text!
        answerCheck = answerCheck.lowercased()
        answerCheck = answerCheck.replacingOccurrences(of: "the ", with: "")
        if (arrAnswers?.contains(answerCheck))! {
            self.rightAnswer()
//            countryGuess.resignFirstResponder()
        }else{
            self.sclAlert(showCloseButton: true, title: "Uh Oh!", subtitle: "Wrong Answer", closeText: "D'oh!", style: .error,  alertContext: "")
//            SCLAlertView().showError("Uh oh!", subTitle: "Wrong Answer",completeText: "D'oh!")
            print("BOO")
        }
        
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
//        var alertViewIcon = UIImage()
//        if(customIcon != ""){
//            alertViewIcon = UIImage(named: customIcon)!
//        }
        alertView.showTitle(
            title, // Title of view
            subTitle: subtitle, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: closeText, // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: colorInt,
            colorTextButton: 0xFFFFFF,
            circleIconImage: warningImage
        )
    }
    
    
    func configureClues() {
        
        for clueView in clueTextViews{
            (clueView as! UITextView).textColor = UIColor.orange
            (clueView as! UITextView).backgroundColor = UIColor.clear
            (clueView as! UITextView).textAlignment = NSTextAlignment.center
        }
        let clueButtonText: NSArray = ["Reveal Clue 1\n1★","Reveal Clue 2\n2★","Reveal Clue 3\n3★"]
        let cluesRevealed: NSArray = [levelCountry.continentRevealed!,levelCountry.capitalRevealed!,levelCountry.clueRevealed!]
        var clueIndex: NSInteger = 0
        for clueButton in clueButtons{
            let buttonTitle = (clueButtonText.object(at: clueIndex) as! String)
            (clueButton as! UIButton).setTitle(buttonTitle, for: UIControlState.normal)
            (clueButton as! UIButton).tintColor = GlobalConstants.defaultBlue
            (clueButton as! UIButton).titleLabel?.textAlignment = NSTextAlignment.center
            (clueButton as! UIButton).titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            (clueButton as! UIButton).contentVerticalAlignment = UIControlContentVerticalAlignment.center
            (clueButton as! UIButton).backgroundColor = UIColor.orange
            (clueButton as! UIButton).layer.cornerRadius = 10
            (clueButton as! UIButton).layer.borderWidth = 0.0
            if (cluesRevealed.object(at: clueIndex) as! NSNumber) == 1 {
                (clueButton as! UIButton).isHidden = true
            }else{
                (clueButton as! UIButton).isHidden = false
            }
            
            clueIndex+=1
        }
        
        clue1.text = levelCountry.continent
        clue2.text = levelCountry.capital
        clue3.text = levelCountry.clue
    }
    
    @IBAction func revealClue(sender: UIButton) {
        
        
    }
    
    @IBAction func revealAnswerAlert() {
        if levelCountry.solved == 0 {
            
            self.sclAlert(showCloseButton: true, title: "Reveal Answer?", subtitle: "10★", closeText: "Cancel", style: .info, alertContext: "revealAnswer")

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
            
            self.loadCountryView()

        }
    }
    
    
    func resetLevel(){
        
    }
    
    
    func rightAnswer(){
        
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
            
        }
        
        
        let thisCountryIdx = countryList.index(of: levelCountryName)
//        thisCountryIdx += 1
        let modCompare = thisCountryIdx!+1
        if(modCompare % 12 != 0){
            let nextCountry = countryList[thisCountryIdx!+1]
            levelCountryName = nextCountry
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Next") {
                self.loadCountry()
            }
            alertView.addButton("Back") {
                self.performSegue(withIdentifier: "backToLevelVC", sender: self)
                self.countryGuess.resignFirstResponder()
            }
            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: 10★")
            
            
        }else{
            

            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
                self.performSegue(withIdentifier: "backToLevelVC", sender: self)
                self.countryGuess.resignFirstResponder()
//                print("Second button tapped")
            }
            alertView.showSuccess("Correct!", subTitle: "Here's Your Reward: 10★")
            
//            let alertController = UIAlertController(title: "Correct!", message: "Here's your reward: 50★!", preferredStyle: .alert)
//            
//            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
//                self.performSegue(withIdentifier: "backToLevelVC", sender: self)
//                self.countryGuess.resignFirstResponder()
//                // ...
//            }
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true) {
//                // ...
//            }
        }
        modified = true

    }
    
    
    
    @IBAction func exitGame(){
        countryGuess.resignFirstResponder()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
