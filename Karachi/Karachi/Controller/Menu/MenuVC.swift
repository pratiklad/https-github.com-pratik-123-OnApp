//
//  MenuVC.swift
//  Karachi
//
//  Created by Bunty on 17/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

protocol DashBoardDelegate {
    func menuToItemClickDelegate(pageTitle : String , pageCount : String)
}

class MenuVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dashBoard : DashBoardDelegate?
    
    var noOfFavRecord : String = "0"
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        DispatchQueue.main.async(execute: {
            var model : PlaceModel = PlaceModel()
            let temp = model.selectFavouriteRecord()
            self.noOfFavRecord = "\(temp.count)"
            
            self.tableView.reloadData()
        })
        
    }
    
    //MARK: Table view delegate method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK : heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ((self.view.frame.size.width / 2) + 30)
    }
    
    //MARK: viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellH")!
        
        
        return cell
    }
    
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuCategory.count + 2)
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let imgMenu = cell.viewWithTag(1) as! UIImageView
        let lblTitle = cell.viewWithTag(2) as! UILabel
        
        let lblNoOfFav = cell.viewWithTag(3) as! UILabel
        
        switch indexPath.row {
        case 0:
            
            lblNoOfFav.isHidden = true
            lblTitle.text = "All Places"
            imgMenu.image = #imageLiteral(resourceName: "ic_nav_all")
            
        case 1 :
            
            lblTitle.text = "Favorites"
            imgMenu.image = #imageLiteral(resourceName: "menuFavorite")
            
            lblNoOfFav.isHidden = false
            lblNoOfFav.text = "\(noOfFavRecord)"
            
        default:
            
            lblNoOfFav.isHidden = true
            
            let dic = menuCategory[indexPath.row - 2]
            lblTitle.text = dic.name
            
            let urlIMG = URL(string: "\(baseImageURLPath)\(dic.icon)")
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    imgMenu.sd_setImage(with: urlIMG, placeholderImage: #imageLiteral(resourceName: "imgPlace"))
                }
            }
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row != 1
        {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            
        }
    }
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row != 0 && indexPath.row != 1
        {
            
        }
       
        switch indexPath.row {
        case 0:
            
            dashBoard?.menuToItemClickDelegate(pageTitle: "All Places", pageCount: "All")

            break
        case 1:
            
            dashBoard?.menuToItemClickDelegate(pageTitle: "Favorites", pageCount: "11111")

            break
        default:
            
            let dic = menuCategory[indexPath.row - 2]
            
            dashBoard?.menuToItemClickDelegate(pageTitle: dic.name, pageCount: dic.cat_id)

            break
        }
        appDelegateObj.closeMenu()
    }
    //=======end table view delegate method
    
    
    //MARK: Button Setting
    @IBAction func btnSetting(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingClickFromMenu"), object: nil)

        appDelegateObj.closeMenu()
    }
    //end setting button
    
    //MARK: Button Map
    @IBAction func btnMep(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MapClickFromMenu"), object: nil)

        appDelegateObj.closeMenu()
    }
    //========end button map======
    
}
