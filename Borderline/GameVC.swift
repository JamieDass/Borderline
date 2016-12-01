//
//  GameVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-28.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData

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
    
//    var levelCountry = NSString()
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
        self.view.backgroundColor = UIColor.orange
        clueTextViews = [clue1,clue2,clue3]
        clueButtons = [clue1Button,clue2Button,clue3Button]

        
        clueView.backgroundColor = GlobalConstants.defaultBlue
        clueView.layer.borderColor = UIColor.orange.cgColor
        clueView.layer.cornerRadius = 10
        clueView.layer.borderWidth = 4.0
        self.countryGuess.delegate = self
        countryGuess.textColor = UIColor.orange
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
        countryGuess.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)        // Do any additional setup after loading the view.
        
        var country: String = (levelCountry.name)!
        country = country.replacingOccurrences(of: " ", with: "_")
        country = country.appending("_mask.png")
        let path:NSString = "Images/Countries/masks/"
        country = path.appending(country as String)
        flagImage = UIImage.init(named: country as String)
        gameImage.image = flagImage
        
        self.configureClues()
        
        
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
    
     @IBAction func showFlag(){
        if levelCountry.flagRevealed == 0 {
            if !flagShown {
                var country: String = (levelCountry.name)!
                country = country.replacingOccurrences(of: " ", with: "_")
                country = country.appending("_clear.png")
                let path:NSString = "Images/Countries/clear/"
                country = path.appending(country as String)
                let flagClearImage = UIImage.init(named: country as String)
                gameImage.image = flagClearImage
                flagShown = true
            }else{
                gameImage.image = flagImage
                flagShown = false
            }
        }
    }
    
     @IBAction func checkAnswer(){
        var allAnswers = levelCountry.answers
        allAnswers = allAnswers?.lowercased()
        
        let arrAnswers = allAnswers?.components(separatedBy: ", ")
        for answer in arrAnswers!{
            print(answer)
        }
        var answerCheck:String = countryGuess.text!
        answerCheck = answerCheck.lowercased()
        answerCheck = answerCheck.replacingOccurrences(of: "the ", with: "")
        
        if (arrAnswers?.contains(answerCheck))! {
            print("YAY")
        }else{
            print("BOO")
        }
        
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
            print((clueButtonText.object(at: clueIndex) as! String))
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
    
    @IBAction func rightAnswer(){
            
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
