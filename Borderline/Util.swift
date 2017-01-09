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

func initLevelCountries(){
//    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
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
//    var level1CountryNames, level2CountryNames, level3CountryNames, level4CountryNames, level5CountryNames, level6CountryNames:NSMutableArray!
    
    let level1CountryNames = NSMutableArray()
    let level2CountryNames = NSMutableArray()
    let level3CountryNames = NSMutableArray()
    let level4CountryNames = NSMutableArray()
    let level5CountryNames = NSMutableArray()
    let level6CountryNames = NSMutableArray()
    
    level1Countries = allCountries.filter() { $0.level == 1 }
//    level1Countries = level1Countries.filter() { $0.solved == 0 }
    level2Countries = allCountries.filter() { $0.level == 2 }
//    level2Countries = level2Countries.filter() { $0.solved == 0 }
    level3Countries = allCountries.filter() { $0.level == 3 }
//    level3Countries = level3Countries.filter() { $0.solved == 0 }
    level4Countries = allCountries.filter() { $0.level == 4 }
//    level4Countries = level4Countries.filter() { $0.solved == 0 }
    level5Countries = allCountries.filter() { $0.level == 5 }
//    level5Countries = level5Countries.filter() { $0.solved == 0 }
    level6Countries = allCountries.filter() { $0.level == 6 }
//    level6Countries = level6Countries.filter() { $0.solved == 0 }
    
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
