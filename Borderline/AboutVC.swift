//
//  AboutVC.swift
//  Borderline
//
//  Created by Jamie Dassoulas on 2017-04-03.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var authorTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.navigationItem.title = "About"
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Arvo", size: 16)!]
        let attributedString = NSMutableAttributedString(string:"Borderline was created by Jamie Dassoulas.\n\nThe \'right answer\' sound was made by grunz, the \'wrong answer\' sound by Tim Gormly, and the \'reveal\' sound by Gabriel Araujo.\n\nThis app also uses \'SCLAlertView\' by Sherzod Max, Victor Radchenko, Bilawal Hameed, and Riz Joj.\n\nThe font is Arvo.", attributes: attributes)
        _ = attributedString.setAsLink(textToFind: "Jamie Dassoulas", linkURL: "http://jamiedass.com")
        _ = attributedString.setAsLink(textToFind: "grunz", linkURL: "https://freesound.org/s/109663/")
        _ = attributedString.setAsLink(textToFind: "Gabriel Araujo", linkURL: "https://freesound.org/s/242501/")
        _ = attributedString.setAsLink(textToFind: "Tim Gormly", linkURL: "https://freesound.org/s/181857/")
        _ = attributedString.setAsLink(textToFind: "Arvo", linkURL: "https://fonts.google.com/specimen/Arvo")
        _ = attributedString.setAsLink(textToFind: "SCLAlertView", linkURL: "https://github.com/vikmeup/SCLAlertView-Swift")

        authorTV.font = UIFont(name: "Arvo", size: 14)
        authorTV.layer.cornerRadius = 10
        authorTV.layer.borderWidth = GlobalConstants.borderWidth
        authorTV.layer.borderColor = GlobalConstants.borderColour.cgColor
        authorTV.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        authorTV.attributedText = attributedString

        authorTV.isScrollEnabled = false
        let fixedWidth = authorTV.frame.size.width
        authorTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = authorTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = authorTV.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        authorTV.frame = newFrame
        // Do any additional setup after loading the view.
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
