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
    fileprivate let reuseIdentifier = "countryCell"
    fileprivate var countries:[Country] = []
//    var fetchResultController:NSFetchedResultsController<AnyObject>!
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    var levelCountries = [NSMutableArray]()
    var levelName = NSString()
    var levelNumber = NSNumber()
    var statusBar = Bool()

    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.orientation.isPortrait {
            statusBar = true
        }else{
            statusBar = false
        }
        updateCollectionViewLayout(with: self.view.bounds.size)
    }

    
    override func viewDidAppear(_ animated: Bool) {
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
//        updateCollectionViewLayout(with: self.view.bounds.size)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.orange
        self.collectionView?.backgroundColor = GlobalConstants.defaultBlue
        self.navigationItem.title = levelName as String
//        updateCollectionViewLayout(with: self.view.frame.size)
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "level == %@", levelNumber)
            do {
                countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        
//        if let array = countries[(indexPath).row] as? [[NSObject:AnyObject]] {
//        var country: NSString = countries[(indexPath as NSIndexPath).row].name!
        
        let countrySel: Country = countries[(indexPath).row]
        var country: String = (countrySel.name)!
        country = country.replacingOccurrences(of: " ", with: "_")
        country = country.appending("_mask_200.png")
        let path:NSString = "Images/Countries/masks/200/"
        country = path.appending(country as String)
//        country = ("Images/Countries/masks/200/" as NSString) + (country)
//        country = "Images/Countries/masks/200/" + (country as String)
        
        let flagImage = UIImage.init(named: country as String)
        let bgView = UIImageView.init(image: flagImage)
        bgView.contentMode = UIViewContentMode.scaleAspectFit
    
        cell.backgroundView = bgView

//        cell.backgroundColor = UIColor.blackColor()
        // Configure the cell
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.tag = indexPath.row
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView,
//            layout collectionViewLayout: UICollectionViewLayout,
//               insetForSectionAtIndex:NSInteger) -> UIEdgeInsets{
//        return UIEdgeInsetsMake(10, 10, 0, 10)
//    }
    
    func collectionView(_ collectionView: UICollectionView,
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        self.updateSize = size
//        self.collectionView!.performBatchUpdates(nil, completion: nil)

        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
            self.statusBar = (size.width > size.height) ? true : false
        self.updateCollectionViewLayout(with: size)
            }, completion: nil)

    }
    
    fileprivate func updateCollectionViewLayout(with size: CGSize) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            
//            print(self.navigationController?.navigationBar.frame.size.height)
//            print("vc w: ",size.width)
//            print("vc h: ",size.height,"\n")

//            print("\n",self.view.frame.size.height)
            let screenSize: CGRect = UIScreen.main.bounds
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

            let vInsets: CGFloat = (size.height-navHeight-sbheight-((4*vertical)+(3*thickSpace)))/2
//            print(vInsets)
            let hInsets: CGFloat = (size.width-((4*horizontal)+(3*thickSpace)))/2

            layout.itemSize = (size.width < size.height) ? CGSize(width: vertical, height: vertical) : CGSize(width: horizontal, height: horizontal)
            layout.minimumLineSpacing = (size.width < size.height) ? thickSpace : thinSpace
            layout.minimumInteritemSpacing = (size.width < size.height) ? thinSpace : thickSpace
            layout.sectionInset = (size.width < size.height) ? UIEdgeInsetsMake(vInsets, 10, vInsets, 10) : UIEdgeInsetsMake(10, hInsets, 0, hInsets)
            layout.invalidateLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameVC{
            let selectedCountry: Country = countries[(sender as! UICollectionViewCell).tag]
        
//            destination.levelCountry = selectedCountry.name! as NSString
            destination.levelCountry = selectedCountry
//            destination.levelCountry = selectedCountry
//            if segue.identifier == "gameSegue"{
//            destination.levelCountry = selectedCountry
//            }
        }
    }
    
    @IBAction func cancelToLevelVC(segue:UIStoryboardSegue) {
    }

    
//    func collectionView(collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        return CGSizeMake(100, 100)
//    }
    
}
