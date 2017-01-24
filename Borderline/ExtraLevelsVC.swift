//
//  ExtraLevelsVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-24.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit

class ExtraLevelsVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usStatesButton: UIButton!
    @IBOutlet weak var formerCountriesButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.configureButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureButtons() {
        let extraLevelButtons: NSArray = [usStatesButton,formerCountriesButton]
        
        for button in extraLevelButtons as! [UIButton]{
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 4.0
            button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
            button.layer.borderColor = GlobalConstants.darkBlue.cgColor
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        }
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
