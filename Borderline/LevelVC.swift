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
    
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    
    
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    var levelCountries = [NSMutableArray]()
    var levelName = NSString()
    var levelNumber = NSNumber()
    var selectedIndex = IndexPath()
    var statusBar = Bool()
    var changed = Bool()

    override func viewWillAppear(_ animated: Bool) {
//        updateCollectionViewLayout(with: self.view.bounds.size)
        updateCollectionViewLayout(with: UIScreen.main.bounds.size)
        self.updateScoreLabel()
        if UIDevice.current.orientation.isPortrait {
            statusBar = true
        }else{
            statusBar = false
        }

        self.collectionView?.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//          updateCollectionViewLayout(with: self.view.bounds.size)
    }
    
    func updateScoreLabel() {
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
//        scoreBarItem.isEnabled = false
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = UIColor.orange
        self.collectionView?.backgroundColor = GlobalConstants.defaultBlue
        self.navigationItem.title = levelName as String
        
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
        return GlobalConstants.countriesPerLevel
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 

//        if let array = countries[(indexPath).row] as? [[NSObject:AnyObject]] {
//        var country: NSString = countries[(indexPath as NSIndexPath).row].name!
        
        let countrySel: Country = countries[(indexPath).row]
                
        
        var flagType : String!
        var flagPath : String!
        if countrySel.flagRevealed == 0 {
            flagType = "_mask_200.png"
            flagPath = "masks/200/"
        }else{
            flagType = "_clear_200.png"
            flagPath = "clear/200/"
        }
        
        var country: String = (countrySel.name)!
        country = country.replacingOccurrences(of: " ", with: "_")
        country = country.appending(flagType)
        
//        print(country)
        
        var path:String = "Images/Countries/"
        path = path.appending(flagPath)
        country = path.appending(country as String)
    
        let flagImage = UIImage.init(named: country as String)
        let bgView = UIImageView.init(image: flagImage)
        bgView.contentMode = UIViewContentMode.scaleAspectFit
    
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.tag = indexPath.row
        var tickImage = UIImage()
        
        if(countrySel.solved == 1){
            tickImage = UIImage.init(named: "Images/Tick.png")!
//            bgView.addSubview(tickView)
        }
//        let combinedImage:UIImage = LevelVC.mergeImages(imageView: bgView)
        let combinedImage:UIImage = self.mergeImages(backgroundImage: flagImage!, foregroundImage: tickImage)
        let combView = UIImageView.init(image: combinedImage)
        combView.contentMode = UIViewContentMode.scaleAspectFit
        
        
        cell.backgroundView = combView
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
        print("transitioning to")
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
            self.statusBar = (size.width > size.height) ? true : false
            self.updateCollectionViewLayout(with: size)
            }, completion: nil)

    }
    
    fileprivate func updateCollectionViewLayout(with size: CGSize) {
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
//            let screenSize: CGRect = (collectionView?.bounds)!
            let screenSize: CGRect = UIScreen.main.bounds
            let navHeight: CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
            let portrait:Bool = (size.height > size.width)
            
            let longMultiplier:CGFloat = GlobalConstants.countriesPerLevel == 12 ? 0.2 : 0.15
//            let nItems:CGFloat = GlobalConstants.countriesPerLevel == 12 ? 4 : 5
            
//            let longSpace:CGFloat = (1.0-(nItems*longMultiplier))/5.0
            
//            let hSpace: CGFloat = portrait ? screenSize.width*0.025 : screenSize.width*longSpace
//            let vSpace: CGFloat = portrait ? (screenSize.height-navHeight)*longSpace : (screenSize.height-navHeight)*0.025
            
            var portraitSize = (screenSize.width/3 > screenSize.height/5) ? (screenSize.height-navHeight)*longMultiplier : screenSize.width*0.3
            
            var landscapeSize =  (screenSize.width/5 > screenSize.height/3) ? (screenSize.height-navHeight)*0.3 : screenSize.width*longMultiplier
            
           let iPad:Bool = UIDevice.current.userInterfaceIdiom == .pad
            
            portraitSize = iPad ? portraitSize : portraitSize*0.95
            landscapeSize = iPad ? landscapeSize : landscapeSize*0.95
            
            layout.itemSize = portrait ? CGSize(width: portraitSize, height: portraitSize) : CGSize(width: landscapeSize, height: landscapeSize)
            
            let hDivisor: CGFloat = portrait ? screenSize.width : screenSize.height
            let vDivisor: CGFloat = portrait ? screenSize.height-navHeight : screenSize.width
            
            let hSpace: CGFloat = ((1-(3*layout.itemSize.height/hDivisor))/4)*hDivisor
            let vSpace: CGFloat = ((1-(5*layout.itemSize.height/vDivisor))/6)*vDivisor
            
            
            layout.minimumLineSpacing = portrait ? vSpace : hSpace
            layout.minimumInteritemSpacing = portrait ? hSpace : vSpace
 
            
            let hInset:CGFloat = iPad ? hSpace : hSpace*0.9
            let vInset:CGFloat = iPad ? vSpace : vSpace*0.5
            
            layout.sectionInset = UIEdgeInsetsMake(vInset, hInset, vSpace, hInset)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameVC{
            let selectedCountry: Country = countries[(sender as! UICollectionViewCell).tag]
        
            destination.levelCountryName = selectedCountry.name!
            destination.countryNumber = (sender as! UICollectionViewCell).tag as NSNumber!
            destination.levelName = levelName as String
        }
    }
    
    @IBAction func cancelToLevelVC(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? GameVC {
            changed = sourceViewController.modified
            let selIdx = NSIndexPath(row: sourceViewController.countryNumber as Int, section: 0)
            selectedIndex = selIdx as IndexPath
        }
    }
    
//    class func mergeImages(imageView: UIImageView) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
//        //        imageView.view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        imageView.superview!.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return image!
//    }
    
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
//        resultImageView.image = newImage
        
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
//    func collectionView(collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        return CGSizeMake(100, 100)
//    }
    
}
