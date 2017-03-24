//
//  SearchVC.swift
//  Karachi
//
//  Created by Bunty on 18/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

class SearchVC: UIViewController , UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var viewNoPlace: UIView!
    
    var model : PlaceModel = PlaceModel()
    var placeArray : [PlaceModel] = []
    
    var searchPlaceArray : [PlaceModel] = []
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search Place...",attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtSearch.delegate = self
        self.placeArray = self.model.selectRecord(page: "search")
    }
    
    //MARK: Textfield delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func searchTextFieldDidChange(_ sender: UITextField) {
        // print("text changed: \(sender.text)")
        if sender.text?.characters.count == 0 {
            
            tableView.isHidden = true
            viewNoPlace.isHidden = false
            sender.resignFirstResponder()
        }
        else {
            
            tableView.isHidden = false
            viewNoPlace.isHidden = true
            
            self.searchAutocompleteEntries(withSubstring: sender.text!)
        }
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        searchPlaceArray = []
        
        let dic1 = placeArray.filter() { $0.name.contains(substring)}
        
        searchPlaceArray = dic1
        
        tableView.reloadData()
    }
    //=============end text field delegate method====
    
    //MARK: Button Back
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    //============end back button======
    
    
    //MARK: Table view delegate method
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPlaceArray.count
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let lblTitle = cell.viewWithTag(1) as! UILabel
        
        let dic = searchPlaceArray[indexPath.row]
        lblTitle.text = dic.name
        
        return cell
    }
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
        
        nextVC.placeModel = searchPlaceArray[indexPath.row]
        nextVC.isFromSearch = true
        
        nextVC.index = indexPath.row
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //end table view delegate method=======
    
}
