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
import AVFoundation
import StoreKit

var player: AVAudioPlayer?

private let fontName = "Arvo"
private var scaledFont: ScaledFont = {
    return ScaledFont(fontName: fontName)
}()


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
    playClick()
    var solvedCountries:[Country] = []
    if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
        // predicate to find all solved countries. CoreData doesn't accept BOOLs so this is stored as NSNumber 0,1
        let solvedNumber:NSNumber = 1
        let solvedPredicate = NSPredicate(format: "solved == %@", solvedNumber)
        let typePredicate = NSPredicate(format: "type == %@", "Country")
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [typePredicate, solvedPredicate])
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

func styleButton (button: UIButton, locked: Bool){
    
    button.layer.cornerRadius = 10
    button.layer.borderWidth = GlobalConstants.borderWidth
    
    button.titleLabel?.numberOfLines = 1
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
    button.titleLabel?.font = scaledFont.font(forTextStyle: UIFontTextStyle.title2)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.layer.shadowRadius = 0
    button.layer.shadowOffset = CGSize(width:5.0,height:5.0)
    button.layer.masksToBounds = false
    button.layer.shadowOpacity = 1
    button.layer.backgroundColor = GlobalConstants.darkBlue.cgColor
    button.layer.borderColor = GlobalConstants.borderColour.cgColor
    button.layer.shadowColor = GlobalConstants.shadowColour.cgColor
button.setTitleColor(UIColor.white, for: .normal)
    
    if(locked){
        button.layer.backgroundColor = GlobalConstants.lightGrey.cgColor
        button.layer.borderColor = GlobalConstants.lightGrey2.cgColor
//        button.layer.shadowColor = GlobalConstants.shadowColour.cgColor
        button.setTitleColor(GlobalConstants.midGrey, for: .normal)
    }
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

func playSound(type: String){
    let defaults = UserDefaults.standard
    if(defaults.bool(forKey: "sounds") == true){
        let soundPath = "Sounds/"+type
        guard let url = Bundle.main.url(forResource: soundPath, withExtension: "wav") else {
            print("error")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

func playClick(){
//    playSound(type: "Select")
//    let defaults = UserDefaults.standard
//    if(defaults.bool(forKey: "sounds") == true){
//        AudioServicesPlaySystemSound(1306)
//    }
}

func initLevelCountries(){
    var allCountries:[Country] = []
    if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
//        fetchRequest.predicate = NSPredicate(format: "type == %@", "Country")
        do {
            allCountries = try managedObjectContext.fetch(fetchRequest) as! [Country]
        } catch {
            print("Failed to retrieve record")
            print(error)
        }
    }
    
    
    var level1Countries, level2Countries, level3Countries, level4Countries, level5Countries, level6Countries, formerCountries, level1States, level2States, level3States, level4States, level5States:[Country]
    
    let level1CountryNames = NSMutableArray()
    let level2CountryNames = NSMutableArray()
    let level3CountryNames = NSMutableArray()
    let level4CountryNames = NSMutableArray()
    let level5CountryNames = NSMutableArray()
    let level6CountryNames = NSMutableArray()
    let formerCountryNames = NSMutableArray()
    
    let level1StateNames = NSMutableArray()
    let level2StateNames = NSMutableArray()
    let level3StateNames = NSMutableArray()
    let level4StateNames = NSMutableArray()
    let level5StateNames = NSMutableArray()

    
    
    
    level1Countries = allCountries.filter() { $0.level == 1 && $0.type == "Country"}
    level2Countries = allCountries.filter() { $0.level == 2 && $0.type == "Country"}
    level3Countries = allCountries.filter() { $0.level == 3 && $0.type == "Country"}
    level4Countries = allCountries.filter() { $0.level == 4 && $0.type == "Country"}
    level5Countries = allCountries.filter() { $0.level == 5 && $0.type == "Country"}
    level6Countries = allCountries.filter() { $0.level == 6 && $0.type == "Country"}
    
    formerCountries = allCountries.filter() { $0.level == 1 && $0.type == "FormerCountry"}

    level1States = allCountries.filter() { $0.level == 1 && $0.type == "State"}
    level2States = allCountries.filter() { $0.level == 2 && $0.type == "State"}
    level3States = allCountries.filter() { $0.level == 3 && $0.type == "State"}
    level4States = allCountries.filter() { $0.level == 4 && $0.type == "State"}
    level5States = allCountries.filter() { $0.level == 5 && $0.type == "State"}
    
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

    for Country in formerCountries{
        formerCountryNames.add(Country.name!)
    }

    for Country in level1States{
        level1StateNames.add(Country.name!)
    }
    for Country in level2States{
        level2StateNames.add(Country.name!)
    }
    for Country in level3States{
        level3StateNames.add(Country.name!)
    }
    for Country in level4States{
        level4StateNames.add(Country.name!)
    }
    for Country in level5States{
        level5StateNames.add(Country.name!)
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
        defaults.set(formerCountryNames, forKey:"Former Countries")
        defaults.set(level1StateNames, forKey:"US States 1")
        defaults.set(level2StateNames, forKey:"US States 2")
        defaults.set(level3StateNames, forKey:"US States 3")
        defaults.set(level4StateNames, forKey:"US States 4")
        defaults.set(level5StateNames, forKey:"US States 5")

    }
    
    
}//initLevelCountries
