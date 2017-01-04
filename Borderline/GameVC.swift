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
            
//            print(viewBottom.constant)
            
//            viewBottom.constant = keyboardHeight
            
            
//            var imgFrame:CGRect = countryView.frame
//            imgFrame.size.height = imgFrame.size.height - keyboardHeight
//            countryView.frame = imgFrame
//            countryView.frame.origin.y = keyboardHeight
//            print(viewBottom.constant)
            
//            UIView.animate(withDuration: 0.1, animations: {self.loadViewIfNeeded()})
//            }
////            print(keyboardHeight)
//            let textfieldHeight = countryGuess.frame.size.height
//            let screenSize: CGRect = UIScreen.main.bounds
//            let availableScreen = screenSize.height-textfieldHeight
//            let frac = keyboardHeight/availableScreen
//            imageHeight.isActive = false
            
//            imageHeight.multiplier = (1.0-frac)
////            print(frac)
//            var imgFrame:CGRect = revealedImageView.frame
//            imgFrame.size.height = availableScreen*(1.0-frac)
//            imgFrame.size.width = availableScreen*(1.0-frac)
//
//            if keyboardHeight > revealedImageView.frame.origin.y {
//                revealedImageView.frame = imgFrame
//            }
            
//            imageBottom.constant = keyboardHeight
//            if keyboardHeight > imageBottom.constant {
//                imageBottom.constant = keyboardHeight
//            }
//            countryGuessConstraint.constant = keyboardHeight
//            countryGuess.frame.origin = CGPoint(x: 0,y: keyboardHeight)
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
        if !cluesShown {
            flagButton.isHidden = true
            revealButton.isHidden = true
            clueView.isHidden = false
            cluesShown = true
        }else{
            flagButton.isHidden = false
            revealButton.isHidden = false
            clueView.isHidden = true
            cluesShown = false
        }
        
    }
    
     @IBAction func showFlagAlert(){
        
        let alertController = UIAlertController(title: "Reveal Flag?", message: "3★", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.revealFlag()
            // ...
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
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
            self.sclAlert(showCloseButton: true, title: "Uh Oh!", subtitle: "Wrong Answer", closeText: "D'oh!", style: .error, colorInt: 0xC1272D, selectorClose: "", selectorNext: "")
//            SCLAlertView().showError("Uh oh!", subTitle: "Wrong Answer",completeText: "D'oh!")
            print("BOO")
        }
        
    }
    
    func sclAlert(showCloseButton: Bool, title: String, subtitle: String, closeText: String, style: SCLAlertViewStyle, colorInt: UInt, selectorClose: String, selectorNext:String){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton:showCloseButton
        )
        
        
//        if(!alertVisible){
//            alertVisible = true
            let alertView = SCLAlertView(appearance: appearance)
        
        if(selectorClose != ""){
            alertView.addButton("Close", target:self, selector:Selector(selectorClose))
        }
        if(selectorNext != ""){
            alertView.addButton("Next", target:self, selector:Selector(selectorNext))
        }

        
        alertView.showTitle(
            title, // Title of view
            subTitle: subtitle, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: closeText, // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: colorInt,
            colorTextButton: 0xFFFFFF
        )
//        }else{
//            alertVisible = false
//        }
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
            let alertController = UIAlertController(title: "Reveal Answer?", message: "10★", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.revealAnswer()
                // ...
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                // ...
            }

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
            let alertController = UIAlertController(title: "Correct!", message: "Here's your reward: 50★!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Back", style: .cancel) { (action) in
                self.countryGuess.resignFirstResponder()
                // ...
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Next", style: .default) { (action) in
                self.loadCountry()
                // ...
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                // ...
            }
            
        }else{
            let alertController = UIAlertController(title: "Correct!", message: "Here's your reward: 50★!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                self.performSegue(withIdentifier: "backToLevelVC", sender: self)
                self.countryGuess.resignFirstResponder()
                // ...
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
                // ...
            }
        }
        modified = true

    }
    
    
    
    @IBAction func exitGame(){
        countryGuess.resignFirstResponder()
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
