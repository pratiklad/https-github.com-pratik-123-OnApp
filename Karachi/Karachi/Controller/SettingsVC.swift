//
//  SettingsVC.swift
//  Karachi
//
//  Created by Bunty on 21/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController , UITableViewDataSource , UITableViewDelegate{

    
    @IBOutlet weak var viewColor: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTermsPolicies: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        viewColor.isHidden = true
        viewColor.frame.origin.x = viewColor.frame.origin.x + self.view.frame.size.width

        
        viewTermsPolicies.isHidden = true
        viewTermsPolicies.frame.origin.x = viewTermsPolicies.frame.origin.x + self.view.frame.size.width

        
        self.view.layoutIfNeeded()
        
    }

    //MARK: Button Back
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //===========end button back
    
    
    //MARK: Button Clear Cache
    @IBAction func btnClearCache(_ sender: Any) {
        
        let alertController = UIAlertController(title: appName  , message:  "Clear Image Cache", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        { action -> Void in
            // Put your code here
        })
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            // Put your code here
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk()
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    //==========end clear cache button
    
    
    //MARK: Button Theme======
    @IBAction func btnTheme(_ sender: Any) {
    
        viewColor.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewColor.frame.origin.x = 0
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    //============end button theme======
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  colorName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        cell.contentView.backgroundColor = getNavigationBarColorCode(index : indexPath.row)
        
        let lblTitle = cell.viewWithTag(1) as! UILabel
        lblTitle.text = colorName[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        preference.set(indexPath.row, forKey: "navColor")
        appDelegateObj.resetNavigationColor()
        
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    @IBAction func btnTerm(_ sender: Any) {
        
        viewTermsPolicies.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewTermsPolicies.frame.origin.x = 0
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    @IBAction func btnRate(_ sender: Any) {
        
        let remoteUrl : NSURL? = NSURL(string: "https://itunes.apple.com/us/app/vtask/id1094692931?ls=1&mt=8")
        UIApplication.shared.openURL(remoteUrl! as URL)

        
    }
    
    @IBAction func btnAbout(_ sender: Any) {
        
        displayAlert(fromController: self, msg: "App display Interesting spot at City")

    }
    
    
    @IBAction func btnOk(_ sender: Any) {
        viewTermsPolicies.isHidden = true
        viewTermsPolicies.frame.origin.x = viewTermsPolicies.frame.origin.x + self.view.frame.size.width
        
        self.view.layoutIfNeeded()
    }
}
