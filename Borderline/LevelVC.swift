//
//  LevelVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2016-08-26.
//  Copyright © 2016 Jetliner. All rights reserved.
//

import UIKit
import CoreData

class LevelVC: UICollectionViewController {
    private let reuseIdentifier = "countryCell"
    private var countries:[Country] = []
    var fetchResultController:NSFetchedResultsController!
    var levelCountries = [NSMutableArray]()
    var levelName = NSString()
    var levelNumber = NSNumber()
    var statusBar = Bool()

    override func viewWillAppear(animated: Bool) {
        if UIDevice.currentDevice().orientation.isPortrait {
            statusBar = true
        }else{
            statusBar = false
        }
        updateCollectionViewLayout(with: self.view.bounds.size)
    }

    
    override func viewDidAppear(animated: Bool) {
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
//        updateCollectionViewLayout(with: self.view.bounds.size)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.orangeColor()
        self.collectionView?.backgroundColor = GlobalConstants.defaultBlue
        self.navigationItem.title = levelName as String
//        updateCollectionViewLayout(with: self.view.frame.size)
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "level == %@", levelNumber)
            do {
                countries = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Country]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
//        print(countries[0].name)

    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) 
        
        var country: NSString = countries[indexPath.row].name!
        country = country.stringByReplacingOccurrencesOfString(" ", withString: "_")
        country = country.stringByAppendingString("_mask_200.png")
        country = "Images/Countries/masks/200/".stringByAppendingString(country as String)
        
        let flagImage = UIImage.init(named: country as String)
        let bgView = UIImageView.init(image: flagImage)
        bgView.contentMode = UIViewContentMode.ScaleAspectFit
    
        cell.backgroundView = bgView
//        cell.backgroundColor = UIColor.blackColor()
        // Configure the cell
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView,
//            layout collectionViewLayout: UICollectionViewLayout,
//               insetForSectionAtIndex:NSInteger) -> UIEdgeInsets{
//        return UIEdgeInsetsMake(10, 10, 0, 10)
//    }
    
    func collectionView(collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
               minimumInteritemSpacingForSectionAtIndex:NSInteger) -> CGFloat{
        return 10
    }
    
//    func collectionView(collectionView: UICollectionView,
//            layout collectionViewLayout: UICollectionViewLayout,
//                minimumLineSpacingForSectionAtIndex:NSInteger) -> CGFloat{
//        return 25
//    }
//

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        self.updateSize = size
//        self.collectionView!.performBatchUpdates(nil, completion: nil)

        coordinator.animateAlongsideTransition({ context in
            // do whatever with your context
            context.viewControllerForKey(UITransitionContextFromViewControllerKey)
            self.statusBar = (size.width > size.height) ? true : false
        self.updateCollectionViewLayout(with: size)
            }, completion: nil)

    }
    
    private func updateCollectionViewLayout(with size: CGSize) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            
//            print(self.navigationController?.navigationBar.frame.size.height)
//            print("vc w: ",size.width)
//            print("vc h: ",size.height,"\n")

//            print("\n",self.view.frame.size.height)
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let navHeight: CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
//            print(screenSize.height)
//            print(screenSize.width)

//            let horizontal: CGFloat = (size.height-40)/3
            let thinSpace: CGFloat = 10
            let thickSpace: CGFloat = 25
            
//            let vertical: CGFloat = (screenSize.height-navHeight-(5*thickSpace))/4
            let vertical: CGFloat = (screenSize.width-(4*thinSpace))/3

            let horizontal: CGFloat = (screenSize.height-navHeight-(4*thinSpace))/3
            var sbheight: CGFloat = 0
            if statusBar {
                sbheight = 20
            }
            print(sbheight)
            let vInsets: CGFloat = (size.height-navHeight-sbheight-((4*vertical)+(3*thickSpace)))/2
//            print(vInsets)
            let hInsets: CGFloat = (size.width-((4*horizontal)+(3*thickSpace)))/2

            layout.itemSize = (size.width < size.height) ? CGSizeMake(vertical, vertical) : CGSizeMake(horizontal, horizontal)
            layout.minimumLineSpacing = (size.width < size.height) ? thickSpace : thinSpace
            layout.minimumInteritemSpacing = (size.width < size.height) ? thinSpace : thickSpace
            layout.sectionInset = (size.width < size.height) ? UIEdgeInsetsMake(vInsets, 10, vInsets, 10) : UIEdgeInsetsMake(10, hInsets, 0, hInsets)
            layout.invalidateLayout()
        }
    }
    
//    func collectionView(collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        return CGSizeMake(100, 100)
//    }
    
}
