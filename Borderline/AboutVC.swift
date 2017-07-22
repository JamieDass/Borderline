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
        
        let attributedString = NSMutableAttributedString(string:"by Jamie Dassoulas")
        attributedString.setAsLink(textToFind: "Jamie Dassoulas", linkURL: "http://jamiedass.com")
//        authorTV.linkTextAttributes = [NSForegroundColorAttributeName: GlobalConstants.lightBlue]
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
