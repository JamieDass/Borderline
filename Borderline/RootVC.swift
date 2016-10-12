//
//  RootVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-21.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        self.navigationItem.title = "Borderline"
        updateLabel()
        scoreLabel?.text = "hello"
    }
    override func viewWillAppear(_ animated: Bool) {
//        scoreLabel.text = " "
    }
    func updateLabel(){
    
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "score") == nil {
            defaults.set(1, forKey: "score")
        }
        let currentScore = defaults.integer(forKey: "score")
//        yourLabel.text = String(currentScore)
//        scoreLabel?.text = String(currentScore)
//        scoreLabel?.text = text
    }
    
}
