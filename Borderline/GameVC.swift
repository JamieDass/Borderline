//
//  GameVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-28.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit

class GameVC: UIViewController {

    @IBOutlet weak var imageBottom: NSLayoutConstraint!
//    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    @IBOutlet weak var revealedImageView: UIImageView!
    
//    @IBOutlet weak var countryGuessConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryGuess: UITextField!
    var keyboardHeight: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize: CGRect = UIScreen.main.bounds
//        imageBottom.constant = screenSize.height/2
        super.viewWillAppear(true)
        
         // Do any additional setup after loading the view.
    }
    
    

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
//            if keyboardHeight > imageBottom.constant {
//                imageBottom.constant = keyboardHeight
//            }
//            countryGuessConstraint.constant = keyboardHeight
//            countryGuess.frame.origin = CGPoint(x: 0,y: keyboardHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revealedImageView.backgroundColor = UIColor.blue
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
