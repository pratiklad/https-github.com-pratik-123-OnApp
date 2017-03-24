//
//  ItemDetailVC.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import MapKit

protocol ItemDetailDelegate {
    func refreshList(index : Int ,dic : PlaceModel )
}

class ItemDetailVC: UIViewController , UITableViewDataSource , UITableViewDelegate , UIScrollViewDelegate , ItemCell1Delegate{

    var delegateItem : ItemDetailDelegate?
    
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnFavoriteObj: UIButton!
    
    
    var header : StretchHeader!
    
    var placeModel : PlaceModel = PlaceModel()
    
    var index : Int = 0
    
    var isFromSearch : Bool = false
    
    
    //MARK: Image view object
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?

    //=========
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupHeaderView()
        
        navigationView.backgroundColor =  getNavigationBarColor()
        navigationView.alpha = 0.0
    }

    //MARK: Table view header setup
    //Parallex tableview header setup
    func setupHeaderView() {
        
        
        if placeModel.favorite
        {
            btnFavoriteObj.setImage(#imageLiteral(resourceName: "ic_nav_fav"), for: .normal)
        }
        else
        {
            btnFavoriteObj.setImage(#imageLiteral(resourceName: "ic_nav_favorites_outline"), for: .normal)
        }
        
        let options = StretchHeaderOptions()
        options.position = .fullScreenTop
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        let urlIMG = URL(string: "\(baseImageURLPath)\(placeModel.image)")
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.header.imageView.sd_setImage(with: urlIMG, placeholderImage: #imageLiteral(resourceName: "imgPlace"))
            }
        }
        header.imageView.contentMode = .scaleAspectFill
        header.imageView.backgroundColor = UIColor.clear
        
        // custom
        let label = UILabel()
        label.frame = CGRect(x: 22, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
        label.textColor = UIColor.white
        
        label.text = placeModel.name
        lblPlaceName.text = placeModel.name
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        header.addSubview(label)
        
        tableView.tableHeaderView = header
    }
    //============end table view header setup=======
    
    //MARK: Button Back
    @IBAction func btnBack(_ sender: Any) {
        
        if !isFromSearch
        {
            delegateItem?.refreshList(index: index, dic: placeModel)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Button Favorite======
    @IBAction func btnFavorite(_ sender: Any) {
        placeModel.favorite = !placeModel.favorite

        if placeModel.favorite
        {
            btnFavoriteObj.setImage(#imageLiteral(resourceName: "ic_nav_fav"), for: .normal)
        }
        else
        {
            btnFavoriteObj.setImage(#imageLiteral(resourceName: "ic_nav_favorites_outline"), for: .normal)
        }
        
        placeModel.updatefavoriteoriteList(page: placeModel.page, place_id: placeModel.place_id, favorite: placeModel.favorite)
    }
    //=============end button favorite======

    
    //MARK: Table view delegate  method

    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            if curLat == 0 && curLong == 0
            {
                let cell : ItemDetailCell0 = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ItemDetailCell0
                
                cell.lblAddress.text = placeModel.address
                cell.lblPhone.text = placeModel.phone == "" ? "do not have a phone" :  placeModel.phone
                cell.lblWebsite.text = placeModel.website == "" ? "do not have a website" :  placeModel.website
                
                return cell
            }
            else
            {
                let cell : ItemDetailCell0 = tableView.dequeueReusableCell(withIdentifier: "cellL")! as! ItemDetailCell0
                
                cell.lblAddress.text = placeModel.address
                cell.lblPhone.text = placeModel.phone == "" ? "do not have a phone" :  placeModel.phone
                cell.lblWebsite.text = placeModel.website == "" ? "do not have a website" :  placeModel.website
                
                cell.lblKM.text = getDistance(lat: placeModel.lat.doubleValue, long: placeModel.lng.doubleValue)
                
                return cell
            }
        }
        else if indexPath.row == 1
        {
            let cell : ItemDetailCell1 = tableView.dequeueReusableCell(withIdentifier: "cell1")! as! ItemDetailCell1
            
            cell.delegate = self
            
            var imgA = placeModel.imagesArray
            imgA.append(ImageModel(place_id: "0", name: placeModel.image))

            cell.imgModel = imgA
            
            return cell
        }
        else if indexPath.row == 2
        {
            let cell  : ItemDetailCell2 = tableView.dequeueReusableCell(withIdentifier: "cell2")! as! ItemDetailCell2
            
            cell.lblDescription.text = placeModel.description
            
            return cell
        }
        else
        {
            let cell : ItemDetailCell3 = tableView.dequeueReusableCell(withIdentifier: "cell3")! as! ItemDetailCell3
            
            
            let w : Int = Int(cell.imgMap.frame.size.width)
            let h : Int = Int(cell.imgMap.frame.size.height)
            
            let staticMapUrl: String = "http://maps.google.com/maps/api/staticmap?markers=color:red|\(placeModel.lat),\(placeModel.lng)&zoom=14&size=\(w)x\(h)&sensor=true"

            let url = NSURL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let urlIMG = url as! URL
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: urlIMG)
                DispatchQueue.main.async {
                    cell.imgMap.image = UIImage(data: data!)
                }
            }
            return cell
        }
    }
   
 
    
    func ImageSliderOpen(imgArray : [InputSource] , initialIndex : Int)  {
      
     
        
        let ctr = FullScreenSlideshowViewController()
       
        
        ctr.initialImageIndex = initialIndex
        
        ctr.inputs =  imgArray
       // slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: self.view as! ImageSlideshow, slideshowController: ctr)
        // Uncomment if you want disable the slide-to-dismiss feature on full screen preview
        // self.transitionDelegate?.slideToDismissEnabled = false
        ctr.transitioningDelegate = slideshowTransitioningDelegate
        self.present(ctr, animated: true, completion: nil)
    }
    
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //=======end table view delegae method
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
        // NavigationHeader alpha update
        let offset : CGFloat = scrollView.contentOffset.y

        if offset > 96 {
            navigationView.alpha = 1.0
        }
        else if (offset > 50 ) {
            //print("iff->\(offset)")
            let alpha : CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(50) + (navigationView.frame.height) - offset) / (navigationView.frame.height))
            navigationView.alpha = CGFloat(alpha)
            
        } else {
            navigationView.alpha = 0.0;
        }
    }
    //==========end scrollViewDidScroll method=========

    
    //MARK: Button VIEW
    @IBAction func btnViewMap(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        
        nextVC.placeModel  = placeModel

        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Button Navigate
    @IBAction func btnNavigateMap(_ sender: Any) {
       
        let latitude: CLLocationDegrees = placeModel.lat.doubleValue
        let longitude: CLLocationDegrees = placeModel.lng.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeModel.address
        
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    @IBAction func btnShareText(_ sender: Any) {
        DispatchQueue.main.async{
            
            let text1 = "View good place \"\(self.placeModel.name)\""
            let text2 = "located at : \(self.placeModel.address)"
            
            let text3 = "Using app \"\(appName)\""
            
            let objectsToShare = [text1,text2,text3]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
            {
                self.present(activityVC, animated: true, completion: nil)
            } else
            { //if iPad
                // Change Rect to position Popover
                let popoverCntlr = UIPopoverController(contentViewController: activityVC)
                popoverCntlr.present(from: CGRect(x : self.view.frame.size.width/2,y: self.view.frame.size.height/4,width : 0, height : 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            }
        }
    }
    
}

