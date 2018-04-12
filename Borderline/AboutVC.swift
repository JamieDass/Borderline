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
        let attributedString = NSMutableAttributedString(string:"by Jamie Dassoulas.\n\nThe \'right answer\' sound was made by grunz, the \'wrong answer\' sound by Tim Gormly, and the \'reveal\' sound by Gabriel Araujo.\nThe font is Arvo.", attributes: attributes)
        _ = attributedString.setAsLink(textToFind: "Jamie Dassoulas", linkURL: "http://jamiedass.com")
        _ = attributedString.setAsLink(textToFind: "grunz", linkURL: "https://freesound.org/s/109663/")
        _ = attributedString.setAsLink(textToFind: "Gabriel Araujo", linkURL: "https://freesound.org/s/242501/")
        _ = attributedString.setAsLink(textToFind: "Tim Gormly", linkURL: "https://freesound.org/s/181857/")
        _ = attributedString.setAsLink(textToFind: "Arvo", linkURL: "https://fonts.google.com/specimen/Arvo")

        authorTV.font = UIFont(name: "Arvo", size: 14)
        authorTV.layer.cornerRadius = 10
        authorTV.attributedText = attributedString
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
