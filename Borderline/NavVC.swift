//
//  NavVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-26.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //        self.updateSize = size
        //        self.collectionView!.performBatchUpdates(nil, completion: nil)
        
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)

            }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
