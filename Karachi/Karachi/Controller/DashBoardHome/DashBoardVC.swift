//
//  DashBoardVC.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import CoreLocation

class DashBoardVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIScrollViewDelegate , DashBoardDelegate , ItemDetailDelegate , CLLocationManagerDelegate{
    
    @IBOutlet weak var viewNoPlace: UIView!
    
    @IBOutlet weak var viewNavigation: NavigationBarClass!
    
    @IBOutlet weak var constraintSubMenuTrailing: NSLayoutConstraint!
    @IBOutlet weak var contraintBottomSearchView: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: CustomView!
    
    @IBOutlet weak var lblTitle: UILabel!
    var model : PlaceModel = PlaceModel()
    var placeArray : [PlaceModel] = []
    
    var pageCounter : String = "1"
    var pageTitle : String = "All Places"
    
    let locationManager = CLLocationManager()
    
    var loadingMoreView:InfiniteScrollActivityView? // For pull to refresh
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        lblTitle.text = pageTitle
        
        if preference.integer(forKey: "isFirstTimeDataLoad") != 0
        {
            
            self.placeArray = self.model.selectRecord(page: pageCounter)
            
            if curLat != 0 && curLong != 0
            {
                self.placeArray = placeArray.sorted(by: {$0.distance < $1.distance})
            }
            
            self.collectionView.reloadData()
            
            let catModle : CategoryMenuModel = CategoryMenuModel()
            catModle.selectRecord()
            
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                // your function here
                
                DispatchQueue.main.async{
                    if Reachability.isConnectedToNetwork() == true
                    {
                        self.getDataFromServer(page: self.pageCounter ,isFirstLoad:  true)
                    }
                    else // display alert
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        displayAlert(fromController: self, msg: "No Internet Connection \nMake sure your device is connected to the internet.")
                    }
                }
            })
            
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                // your function here
                
                DispatchQueue.main.async{
                    if Reachability.isConnectedToNetwork() == true
                    {
                        self.getDataFromServer(page: self.pageCounter , isFirstLoad:  true)
                    }
                    else // display alert
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        displayAlert(fromController: self, msg: "No Internet Connection \nMake sure your device is connected to the internet.")
                    }
                }
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.btnSettings(_:)), name: NSNotification.Name(rawValue: "SettingClickFromMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openMapDetailPage), name: NSNotification.Name(rawValue: "MapClickFromMenu"), object: nil)
        
        
        DispatchQueue.global(qos: .background).async {
            // self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled()
            {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x : 0,y: collectionView.contentSize.height,width : collectionView.bounds.size.width,height : InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionView.addSubview(loadingMoreView!)
        
    }
    
    func menuToItemClickDelegate(pageTitle : String , pageCount : String)  {
        
        lblTitle.text = pageTitle
        pageCounter  = pageCount
        
        if pageCount == "11111"
        {
            self.placeArray = self.model.selectFavouriteRecord()
            
            if curLat != 0 && curLong != 0
            {
                self.placeArray = placeArray.sorted(by: {$0.distance < $1.distance})
            }
            
            self.collectionView.reloadData()
        }
        else if pageCount == "All"
        {
            self.placeArray = self.model.selectRecord(page: "1")
            
            
           // self.model.DistanceWiseFilter(palceArray: self.placeArray)

            if curLat != 0 && curLong != 0
            {
                self.placeArray = placeArray.sorted(by: {$0.distance < $1.distance})
            }
            self.collectionView.reloadData()
            
            let catModle : CategoryMenuModel = CategoryMenuModel()
            catModle.selectRecord()
        }
        else
        {
            self.placeArray = self.model.selectRecord(page: "1")
            
            let dic1 = placeArray.filter() { $0.cat_id.components(separatedBy: "&&&").contains(pageCount)}
            
           // self.placeArray = dic1
            
            if curLat != 0 && curLong != 0
            {
                self.placeArray  =  dic1.sorted(by: {$0.distance < $1.distance})
            }
            
            self.collectionView.reloadData()
            
            let catModle : CategoryMenuModel = CategoryMenuModel()
            catModle.selectRecord()
        }
        
        closeSubMenu()
        
        self.searchView.frame.origin.y = (self.view.frame.maxY - 70)
        //self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewNavigation.backgroundColor = getNavigationBarColor()
    }
    
    
    //MARK: button Menu
    @IBAction func btnMenu(_ sender: Any) {
        
        closeSubMenu()
        appDelegateObj.openMenu(controller: self)
    }
    
    //MARK: Collection View delegate method
    //MARK: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if placeArray.count == 0
        {
            viewNoPlace.isHidden = false
        }
        else
        {
            viewNoPlace.isHidden = true
        }
        
        return placeArray.count
    }
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if curLat == 0 && curLong == 0
        {
            let cell : DashboardCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCell
            
            
            let dic = placeArray[indexPath.row]
            cell.lblPlaceName.text = dic.name
            
            let urlIMG = URL(string: "\(baseImageURLPath)\(dic.image)")
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    cell.imgPlace.sd_setImage(with: urlIMG, placeholderImage: #imageLiteral(resourceName: "imgPlace"))
                }
            }
            
            return cell
        }
        else
        {
            let cell : DashboardCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! DashboardCell
            
            
            let dic = placeArray[indexPath.row]
            cell.lblPlaceName.text = dic.name
            
            cell.lblKM.text = getDistance(lat: dic.lat.doubleValue, long: dic.lng.doubleValue)
            
            let urlIMG = URL(string: "\(baseImageURLPath)\(dic.image)")
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    cell.imgPlace.sd_setImage(with: urlIMG, placeholderImage: #imageLiteral(resourceName: "imgPlace"))
                }
            }
            
            return cell
        }
    }
    
    //MARK: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        closeSubMenu()
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
        
        nextVC.placeModel = placeArray[indexPath.row]
        
        nextVC.index = indexPath.row
        nextVC.delegateItem = self
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func refreshList(index : Int ,dic : PlaceModel )
    {
        
        if  pageCounter == "11111"
        {
            if !dic.favorite
            {
                placeArray.remove(at: index)
                collectionView.reloadData()
            }
        }
        else
        {
            placeArray[index] = dic
            collectionView.reloadData()
        }
    }
    
    
    //MARK: collectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vW = (view.frame.size.width / 2) - 10
        
        return CGSize(width:  vW , height: vW)
    }
    //MARK: insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
    }
    //=======end delegate method==========
    
    
    //MARK : Scrollview delegate method
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        closeSubMenu()
        UIView.animate(withDuration: 0.5, animations: {
            self.contraintBottomSearchView.constant = -20
            
            self.searchView.frame.origin.y = (self.view.frame.maxY + 50)
            self.view.layoutIfNeeded()
            
        }, completion: { com in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.searchView.frame.origin.y = (self.view.frame.maxY - 70)
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        })
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.searchView.frame.origin.y = (self.view.frame.maxY - 70)
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    //==========end scroll view delegate mehtod=========
    
    
    var isRefresh : Bool = false
    //MARK:  getDataFromServer
    //get list from server add by bunty 18-03-2017
    func getDataFromServer(page : String , isFirstLoad : Bool)  {
        
        let url = "\(baseURL)/listPlaces?page=\(pageIndex)&count=50&draft=0"
        
        SendServerRequest(type: "GET", baseURL: url, param: "" as AnyObject, requestCompleted: {(success,msg,jsonObj)in
            if success
            {
                guard let jsonDic = jsonObj as? NSDictionary else{
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    displayAlert(fromController: self, msg: "Error while retriving data")
                    return
                }
                
                
                guard let status =  jsonDic.value(forKey: "status") as? String, status == "success" else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    return
                }
                
                
                var counttotal : String = ""
                if jsonDic.value(forKey: "count_total") is String
                {
                    counttotal = jsonDic.value(forKey: "count_total") as! String
                }
                else if jsonDic.value(forKey: "count_total") is NSNumber
                {
                    let  p = jsonDic.value(forKey: "count_total") as! NSNumber
                    
                    counttotal = "\(p)"
                }
                
                count_total = Int(counttotal)!
                
                guard let jsonArray =  jsonDic.value(forKey: "places") as? NSArray else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                total_Load_Count += jsonArray.count
                pageIndex += 1
                self.isRefresh = false
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.placeArray = self.model.traversServerResponse(array: jsonArray,page : "1")
                    
                    self.placeArray = self.model.selectRecord(page: "1")
                    
                    if isFirstLoad
                    {
                        if page == "Refresh"
                        {
                            self.loadingMoreView!.stopAnimating()
                        }
                    }
                    else
                    {
                        if self.pageCounter == "All"
                        {
                            // self.placeArray = self.model.selectRecord(page: "1")
                        }
                        else
                        {
                            if self.lblTitle.text == "All Places"
                            {
                                //  self.placeArray = self.model.selectRecord(page: "1")
                            }
                            else
                            {
                                let dic1 = self.placeArray.filter() { $0.cat_id.components(separatedBy: "&&&").contains(self.pageCounter)}
                                self.placeArray = dic1
                            }
                        }
                    }
                    
                })
            }
            else
            {
                displayAlert(fromController: self, msg: msg)
            }
            
            if !isFirstMenuLoad
            {
                self.getCategoryDataFromServer()
                isFirstMenuLoad = true
            }
            
            
            DispatchQueue.main.async(execute: {
                
                if curLat != 0 && curLong != 0
                {
                    self.placeArray = self.placeArray.sorted(by: {$0.distance < $1.distance})
                }
                self.collectionView.reloadData()
            })
            
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    //===============end api list get===================
    
    
    //Load More Data
    //MARK: ScrollView Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if lblTitle.text == "All Places"
        {
            if count_total > total_Load_Count
            {
                // Calculate the position of one screen length before the bottom of the results
                let scrollViewContentHeight = collectionView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
                
                if !self.isRefresh
                {
                    // When the user has scrolled past the threshold, start requesting
                    if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                        
                        self.isRefresh = true
                        // Update position of loadingMoreView, and start loading indicator
                        let frame = CGRect(x : 0,y:  collectionView.contentSize.height,width : collectionView.bounds.size.width,height : InfiniteScrollActivityView.defaultHeight)
                        loadingMoreView?.frame = frame
                        
                        
                        // Code to load more results
                        loadingMoreView!.startAnimating()
                        
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            // your function here
                            
                            DispatchQueue.main.async{
                                if Reachability.isConnectedToNetwork() == true
                                {
                                    self.getDataFromServer(page: "Refresh", isFirstLoad:  true)
                                }
                                else // display alert
                                {
                                    self.isRefresh  = false
                                    self.loadingMoreView!.stopAnimating()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    //====end load more data
    
    func getCategoryDataFromServer() {
        
        let url = "\(baseURL)/getCategories?"
        
        SendServerRequest(type: "GET", baseURL: url, param: "" as AnyObject, requestCompleted: {(success,msg,jsonObj)in
            if success
            {
                guard let jsonDic = jsonObj as? NSDictionary else{
                    
                    return
                }
                
                guard let jsonArray =  jsonDic.value(forKey: "cat") as? NSArray else{
                    
                    return
                }
                
                
                DispatchQueue.main.async(execute: {
                    var menuObj : CategoryMenuModel = CategoryMenuModel()
                    
                    menuObj.traversServerResponse(array: jsonArray)
                    
                    
                })
                
                
                preference.set(1, forKey: "isFirstTimeDataLoad")
            }
            else
            {
                displayAlert(fromController: self, msg: msg)
            }
        })
    }
    
    //MARK: Button Search
    @IBAction func btnSearch(_ sender: Any) {
        
        closeSubMenu()
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //===========end search button=============
    
    
    //MARK: Button Refresh===
    @IBAction func btnRefresh(_ sender: Any) {
        
        if pageCounter == "11111"
        {
            self.placeArray = self.model.selectFavouriteRecord()
            if curLat != 0 && curLong != 0
            {
                self.placeArray = placeArray.sorted(by: {$0.distance < $1.distance})
            }
            self.collectionView.reloadData()
        }
        else if lblTitle.text == "All Places"
        {
            
            total_Load_Count = 0
            count_total = 0
            pageIndex  = 1
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                // your function here
                
                DispatchQueue.main.async{
                    if Reachability.isConnectedToNetwork() == true
                    {
                        self.getDataFromServer(page: "1" , isFirstLoad:  false)
                    }
                    else // display alert
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        displayAlert(fromController: self, msg: "No Internet Connection \nMake sure your device is connected to the internet.")
                    }
                }
            })
        }
        else
        {
            DispatchQueue.main.async(execute: {
                self.placeArray = self.model.selectRecord(page: "1")
                let dic1 = self.placeArray.filter() { $0.cat_id.components(separatedBy: "&&&").contains(self.pageCounter)}
                self.placeArray = dic1
                
                if curLat != 0 && curLong != 0
                {
                    self.placeArray = self.placeArray.sorted(by: {$0.distance < $1.distance})
                }
                self.collectionView.reloadData()
            })
            
        }
        closeSubMenu()
    }
    //=============end refresh button
    
    
    //MARK: Button Submenu====
    @IBAction func btnSubMenu(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.constraintSubMenuTrailing.constant = 5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    //==============end submenu ======
    
    //MARK: Button Setting =======
    @IBAction func btnSettings(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        navigationController?.present(nextVC, animated: true, completion: nil)
        
        closeSubMenu()
    }
    //==========end setting======
    
    //MARK: Button Rate Us ========
    @IBAction func btnRateUs(_ sender: Any) {
        
        let remoteUrl : NSURL? = NSURL(string: "https://itunes.apple.com/us/app/vtask/id1094692931?ls=1&mt=8")
        UIApplication.shared.openURL(remoteUrl! as URL)
        
        closeSubMenu()
    }
    //===========end rate us =======
    
    //MARK: Button About
    @IBAction func btnAbout(_ sender: Any) {
        
        displayAlert(fromController: self, msg: "App display Interesting spot at City")
        closeSubMenu()
    }
    //==end button about====
    
    //MARK: closeSubMenu
    func closeSubMenu()  {
        if constraintSubMenuTrailing.constant == 5
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.constraintSubMenuTrailing.constant = -216
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
        
    }
    //==========end submenu close=====
    
    //MARK: Open Map Detail page======
    func openMapDetailPage()  {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        
        nextVC.isFromMenuSetting = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //=============end map detail page========
    
    //MARK: Location Delegate method======
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error retriving for update location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if error != nil
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            else
            {
                if manager.location?.coordinate != nil
                {
                    
                    let locVal : CLLocationCoordinate2D = (manager.location?.coordinate)!
                    
                    //  print(locVal.latitude)
                    //  print(locVal.longitude)
                    
                    curLat = locVal.latitude
                    curLong = locVal.longitude
                    
                    if curLat != 0 && curLong != 0
                    {
                        self.placeArray = self.placeArray.sorted(by: {$0.distance < $1.distance})
                    }
                    self.collectionView.reloadData()
                    
                    self.locationManager.stopUpdatingLocation()
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            displayAlert(fromController: self, msg: "Restricted Access to location")
        case CLAuthorizationStatus.denied:
            displayAlert(fromController: self, msg: "User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            
            print("status not ditermided")
            //displayAlert(fromController: self, msg: "Status not determined")
            
        default:
            
            shouldIAllow = true
        }
        
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access:")
        }
    }
    //================end location delegate method===========
}
