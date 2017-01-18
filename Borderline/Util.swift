//
//  Util
//  Borderline
//
//  Created by James Dassoulas on 2017-01-05.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SCLAlertView

func updateScore(increment : Int){
    let defaults = UserDefaults.standard
    var score:Int = defaults.integer(forKey: "score")
    score += increment
    defaults.set(score, forKey: "score")
}

func getScore() -> Int{
    let defaults = UserDefaults.standard
    let score:Int = defaults.integer(forKey: "score")
    return score
}

func showProgress(alert: SCLAlertView){
    var solvedCountries:[Country] = []
    if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
        // predicate to find all solved countries. CoreData doesn't accept BOOLs so this is stored as NSNumber 0,1
        let solvedNumber:NSNumber = 1
        fetchRequest.predicate = NSPredicate(format: "solved == %@", solvedNumber)
        do {
            solvedCountries = try managedObjectContext.fetch(fetchRequest) as! [Country]
        } catch {
            print("Failed to retrieve record")
            print(error)
        }
    }
    
    let score = "Score: "+String(getScore())+"★"
    var levelProgress = "\n"
    var lvl:Int = 1
    while lvl <= 6{
        let passedLevel:Int = solvedCountries.filter{ $0.level == NSNumber(value: lvl) }.count
        var space:String = ""
        if(passedLevel < 10){
            space = " "
        }
        levelProgress += "Level "+String(lvl)+":\t\t"+space+String(passedLevel)+"/15"
        if(lvl != 6){
            levelProgress = levelProgress+"\n"
        }
        lvl += 1
    }
    alert.showInfo(score, subTitle: levelProgress,closeButtonTitle: "Cool!")
}

func progressApp(showCloseButton: Bool) -> SCLAlertView.SCLAppearance{
    let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "SFMono-Semibold", size: 20)!,
        kTextFont: UIFont(name: "SFMono-Semibold", size: 18)!,
        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
        showCloseButton: showCloseButton
    )
    return appearance
}

func mergeImages (backgroundImage : UIImage, foregroundImage : UIImage) -> UIImage {
    
    let bottomImage = backgroundImage
    let topImage = foregroundImage
    
    let size = backgroundImage.size
    let tickSize = size.width/4
    UIGraphicsBeginImageContext(size)
    
    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let tickareaSize = CGRect(x: size.width-tickSize-2, y: size.height-tickSize-2, width: tickSize, height: tickSize)
    bottomImage.draw(in: areaSize)
    
    topImage.draw(in: tickareaSize, blendMode: .normal, alpha: 1.0)
    
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
    UIGraphicsEndImageContext()
    return newImage
    
}

func initLevelCountries(){
    var allCountries:[Country] = []
    if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
        do {
            allCountries = try managedObjectContext.fetch(fetchRequest) as! [Country]
        } catch {
            print("Failed to retrieve record")
            print(error)
        }
    }
    
    
    var level1Countries, level2Countries, level3Countries, level4Countries, level5Countries, level6Countries:[Country]
    
    let level1CountryNames = NSMutableArray()
    let level2CountryNames = NSMutableArray()
    let level3CountryNames = NSMutableArray()
    let level4CountryNames = NSMutableArray()
    let level5CountryNames = NSMutableArray()
    let level6CountryNames = NSMutableArray()
    
    level1Countries = allCountries.filter() { $0.level == 1 }
    level2Countries = allCountries.filter() { $0.level == 2 }
    level3Countries = allCountries.filter() { $0.level == 3 }
    level4Countries = allCountries.filter() { $0.level == 4 }
    level5Countries = allCountries.filter() { $0.level == 5 }
    level6Countries = allCountries.filter() { $0.level == 6 }
    
    for Country in level1Countries{
        level1CountryNames.add(Country.name!)
    }
    for Country in level2Countries{
        level2CountryNames.add(Country.name!)
    }
    for Country in level3Countries{
        level3CountryNames.add(Country.name!)
    }
    for Country in level4Countries{
        level4CountryNames.add(Country.name!)
    }
    for Country in level5Countries{
        level5CountryNames.add(Country.name!)
    }
    for Country in level6Countries{
        level6CountryNames.add(Country.name!)
    }

    
    let defaults = UserDefaults.standard
    if (defaults.integer(forKey: "levelLists") != 1)
    {
        print("creating level lists")
        defaults.set(1, forKey: "levelLists")
        defaults.set(level1CountryNames, forKey:"Level 1")
        defaults.set(level2CountryNames, forKey:"Level 2")
        defaults.set(level3CountryNames, forKey:"Level 3")
        defaults.set(level4CountryNames, forKey:"Level 4")
        defaults.set(level5CountryNames, forKey:"Level 5")
        defaults.set(level6CountryNames, forKey:"Level 6")
    }
    
    
}//initLevelCountries
