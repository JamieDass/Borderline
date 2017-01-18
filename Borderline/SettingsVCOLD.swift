//
//  SettingsVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-13.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class SettingsVCOLD: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var reuseIDs:[String] = ["soundCell","resetProgressCell"]
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: reuseIDs[indexPath.row], for: indexPath)
        
//        if(indexPath.row == 0){
        if(cell.reuseIdentifier == "soundCell"){
            if let soundToggle = cell.viewWithTag(11) as? UISwitch {
                soundToggle.onTintColor = GlobalConstants.darkBlue
                soundToggle.addTarget(self, action: #selector(switchToggled), for: UIControlEvents.valueChanged)
            }
        }
     // Configure the cell...
     
     return cell
     }
 
    func switchToggled(switchState: UISwitch) {
        let defaults = UserDefaults.standard
        if switchState.isOn {
            defaults.set(true, forKey: "sounds")
            print("switchedOn")
            //            myTextField.text = "The Switch is On"
        } else {
            defaults.set(false, forKey: "sounds")
            print("switchedOff")
            //            myTextField.text = "The Switch is Off"
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
