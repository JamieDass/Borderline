//
//  GameVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-28.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit

class GameVC: UIViewController {


    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    
//    @IBOutlet weak var countryGuessConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryGuess: UITextField!
    var keyboardHeight: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
//        let screenSize: CGRect = UIScreen.main.bounds
//        imageBottom.constant = screenSize.height/2
        super.viewWillAppear(true)
        
         // Do any additional setup after loading the view.
    }
    
    

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height

            UIView.animate(withDuration: 0.5, animations: {self.viewBottom.constant = keyboardHeight})
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
        self.view.backgroundColor = GlobalConstants.defaultBlue
//        revealedImageView.backgroundColor = UIColor.blue
        countryGuess.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
