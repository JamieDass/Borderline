//
//  SettingsTVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-12-02.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class SettingsTVC: UITableViewController{
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var soundCell: UITableViewCell!
    @IBOutlet var settingsTable: UITableView!
    @IBOutlet weak var resetProgressCell: UITableViewCell!
    
    
    
    let cellIDs:NSArray = ["soundCell","resetProgressCell"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "sounds") == nil)
        {
            print("creating sound bool")
            defaults.set(true, forKey: "sounds")
        }
        
        if defaults.bool(forKey: "sounds") == true {
            print("sound bool true")
            soundSwitch.isOn = true
        }else{
            print("sound bool false")
            soundSwitch.isOn = false
        }
        
        self.view.backgroundColor = GlobalConstants.defaultBlue
        settingsTable.backgroundColor = GlobalConstants.defaultBlue
        resetProgressCell.backgroundColor = GlobalConstants.defaultBlue
        soundCell.backgroundColor = GlobalConstants.defaultBlue
        soundSwitch.onTintColor = UIColor.orange
        
        soundSwitch.addTarget(self, action: #selector(switchToggled), for: UIControlEvents.valueChanged)
        
//        if let soundToggle = soundCell.viewWithTag(11) as? UISwitch {
//            soundToggle.onTintColor = UIColor.orange
//        }
        settingsTable.sectionHeaderHeight = 10
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        settingsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIDs[indexPath.section] as! String)
//        let cell = settingsTable.dequeueReusableCell(withIdentifier: cellIDs[indexPath.section] as! String, for: indexPath as IndexPath)
//        
//        cell.backgroundColor = GlobalConstants.defaultBlue
//        
//        return cell
//    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("selected")
//        let selectedCell: UITableViewCell = settingsTable.cellForRow(at: indexPath as IndexPath)!
//        if selectedCell == resetProgressCell {
//            self.resetProgress()
//        }
//    }

    func batchUpdate(){
        
        let alertView = SCLAlertView()
        alertView.addButton("Reset"){
            self.resetProgress()
        }
        alertView.showTitle(
            "Are You Sure?", // Title of view
            subTitle: "This Will Reset Your Progress and Your Score", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .warning, // Styles - see below.
            colorStyle: 0xE96719,
            colorTextButton: 0xFFFFFF
        )
        
//        let alertController = UIAlertController(title: "Are you sure?", message: "This will reset your progress and your score.", preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            // ...
//        }
//        alertController.addAction(cancelAction)
//        
//        let OKAction = UIAlertAction(title: "Reset", style: .default) { (action) in
//            self.resetProgress()
//            // ...
//        }
//        alertController.addAction(OKAction)
//        
//        self.present(alertController, animated: true) {
//            // ...
//        }

    }
    
    
    
    func resetProgress(){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "score")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Country")
        batchUpdateRequest.propertiesToUpdate = ["solved": 0, "continentRevealed": 0, "capitalRevealed": 0, "clueRevealed": 0, "flagRevealed": 0]
        
        
        
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        
        do{
            let objectIDs = try managedContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            let objects = objectIDs.result as! [NSManagedObjectID]
            
            objects.forEach({ objID in
                let managedObject = managedContext.object(with: objID)
                managedContext.refresh(managedObject, mergeChanges: false)
            })
        } catch {
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            self.batchUpdate()
        }

//        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!

    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIDs[indexPath.section] as! String)
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[indexPath.section] as! String, for: indexPath as IndexPath)
//        cell.textLabel?.textColor = UIColor.orange
//        cell.backgroundColor = GlobalConstants.defaultBlue
//        
//        return cell
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
