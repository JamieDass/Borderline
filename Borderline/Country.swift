//
//  Country.swift
//  CoreDataPreloadDemo
//
//  Created by James Dassoulas on 2016-08-26.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import CoreData

class Country: NSManagedObject {
    
    @NSManaged var level:NSNumber?
    @NSManaged var name:String?
    @NSManaged var answers:String?
    @NSManaged var continent:String?
    @NSManaged var capital:String?
    @NSManaged var clue:String?
    @NSManaged var solved:NSNumber?
    @NSManaged var continentRevealed:NSNumber?
    @NSManaged var capitalRevealed:NSNumber?
    @NSManaged var clueRevealed:NSNumber?
    @NSManaged var flagRevealed:NSNumber?
    
}