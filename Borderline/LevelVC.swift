//
//  LevelVC.swift
//  Borderline
//
//  Created by James Dassoulas on 2017-01-11.
//  Copyright © 2017 Jetliner. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import AVFoundation

class LevelVC: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    fileprivate let reuseIdentifier = "countryCell"
    fileprivate var countries:[Country] = []

    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    var levelCountries = [NSMutableArray]()
    var levelName = NSString()
    var levelNumber = NSNumber()
    var selectedIndex = IndexPath()
    var statusBar = Bool()
    var changed = Bool()
    
    var levelType = String()
    var countryPath = String()
    
    var flagType : String!
    var flagPath : String!
    var rootPath : String!
    var path : String!
    
    var tickImage = UIImage()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scoreBarItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        updateCollectionViewLayout(with: UIScreen.main.bounds.size)
        self.updateScoreLabel()
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named:"Images/Backgrounds/Pinstripes.png")
        self.updateScoreLabel()
        self.navigationItem.title = levelName as String
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {

            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Country")
            fetchRequest.fetchBatchSize = GlobalConstants.countriesPerLevel
            let levelPredicate = NSPredicate(format: "level == %@", levelNumber)
            let typePredicate = NSPredicate(format: "type == %@", levelType)
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [levelPredicate, typePredicate])
            do {
                countries = try managedObjectContext.fetch(fetchRequest) as! [Country]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        switch levelType {
        case "State":
            countryPath = "States"
        case "FormerCountry":
            countryPath = "FormerCountries"
        default:
            countryPath = "Countries"
        }
        rootPath = "Images/"+countryPath+"/"
        
        tickImage = UIImage.init(named: "Images/Tick.png")!
        collectionView.layoutIfNeeded()
//        print(collectionView.visibleCells.count)
//        print(collectionView.indexPathsForVisibleItems.count)

        // Do any additional setup after loading the view.
    }
    
    func updateScoreLabel() {
        let defaults = UserDefaults.standard
        let score:Int = defaults.integer(forKey: "score")
        let scoreLabel = String(score)+"★"
        scoreBarItem.title = scoreLabel
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch levelType {
            case "State":
                return 10
            case "FormerCountry":
                return 5
            default:
                return GlobalConstants.countriesPerLevel
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt minimumInteritemSpacingForSectionAtIndex:NSInteger) -> CGFloat{
        return 10
    }
    
    @IBAction func gameProgress(){
//        showProgress()
        let alert = SCLAlertView(appearance: progressApp(showCloseButton: true))
        showProgress(alert: alert)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        playSound(type: "Click")
//        AudioServicesPlaySystemSound(1306)
        playClick()
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        let countrySel: Country = countries[(indexPath).row]
        
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
        
        path = rootPath.appending(flagPath)
        country = path.appending(country as String)
        let flagImage = UIImage.init(named: country as String)
        let bgView = UIImageView.init(image: flagImage)
        bgView.contentMode = UIViewContentMode.scaleAspectFit
       
        var combinedImage:UIImage = flagImage!
        if(countrySel.solved == 1){
            combinedImage = mergeImages(backgroundImage: flagImage!, foregroundImage: tickImage)
        }
//        let combinedImage:UIImage = mergeImages(backgroundImage: flagImage!, foregroundImage: tickImage)
        let combView = UIImageView.init(image: combinedImage)
        combView.contentMode = UIViewContentMode.scaleAspectFit
        cell.backgroundView = combView

        cell.layer.borderWidth = 0
//        cell.layer.borderColor = UIColor.clear.cgColor
        cell.tag = indexPath.row
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            // do whatever with your context
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
            self.statusBar = (size.width > size.height) ? true : false
            self.updateCollectionViewLayout(with: size)
        }, completion: nil)
        
    }
    
    fileprivate func updateCollectionViewLayout(with size: CGSize) {
//        let collectionViewLayout = UICollectionViewFlowLayout()
//        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
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
//            print(selectedCountry.name!,"\t",(sender as! UICollectionViewCell).tag as NSNumber!,"\t",levelName as String,"\t",levelType)
            destination.levelCountryName = selectedCountry.name!
            destination.countryNumber = (sender as! UICollectionViewCell).tag as NSNumber!
            destination.levelName = levelName as String
            destination.levelType = levelType
        }
    }
    
    @IBAction func cancelToLevelVC(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? GameVC {
            changed = sourceViewController.modified
            let selIdx = NSIndexPath(row: sourceViewController.countryNumber as! Int, section: 0)
            selectedIndex = selIdx as IndexPath
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
