//
//  Util
//  Borderline
//
//  Created by James Dassoulas on 2017-01-05.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import Foundation

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
