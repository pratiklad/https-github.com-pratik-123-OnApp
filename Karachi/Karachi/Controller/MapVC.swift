//
//  MapVC.swift
//  Karachi
//
//  Created by Bunty on 18/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController , UITableViewDelegate , UITableViewDataSource ,GMSMapViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewSubMenu: CustomView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var trailSubMenuContrain: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var placeModel : PlaceModel = PlaceModel()
    
    var model : PlaceModel = PlaceModel()
    var placeArray : [PlaceModel] = []
    
    var isFromMenuSetting : Bool = false
    
    //Cluster ====obj===
    var markers : [GMSMarker] = []
    var clusterManager_ : GClusterManager = GClusterManager()
    //end cluster
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        mapView.delegate = self
        clusterManager_.delegate = self
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        
        if isFromMenuSetting
        {
            lblTitle.text = "All Places"
            
            self.placeArray = self.model.selectRecord(page: "1")
            self.tableView.reloadData()
            self.markerSetOnMap()
        }
        else
        {
            lblTitle.text = placeModel.name
            var bounds : GMSCoordinateBounds = GMSCoordinateBounds()
            
            let lat : CLLocationDegrees = CLLocationDegrees(placeModel.lat.doubleValue)
            
            let long : CLLocationDegrees = CLLocationDegrees(placeModel.lng.doubleValue)
            
            let marker:GMSMarker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.icon = #imageLiteral(resourceName: "ic_marker")
            bounds = bounds.includingCoordinate(marker.position)
            marker.title = placeModel.name
            marker.map = mapView
            //mapView.selectedMarker = marker
            
            if curLat != 0 && curLong != 0
            {
                let lat : CLLocationDegrees = CLLocationDegrees(curLat)
                let lng : CLLocationDegrees = CLLocationDegrees(curLong)
                
                let loc : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                bounds = bounds.includingCoordinate(loc)
            }
            
            //map move on marker bounds
            let update = GMSCameraUpdate.fit(bounds, withPadding: 20.0)
            mapView.moveCamera(update)
            mapView.animate(with: update)
        }
    }
    
    //MARK: Button Back
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Button Sub Menu
    @IBAction func btnSubMenu(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.trailSubMenuContrain.constant = 5
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: Table View delegate method
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuCategory.count + 1)
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let lblTitle = cell.viewWithTag(1) as! UILabel
        
        if indexPath.row == 0
        {
            lblTitle.text = "All Places"
        }
        else
        {
            let dic = menuCategory[indexPath.row - 1]
            lblTitle.text = dic.name
        }
        
        return cell
    }
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var pageCounter : String = "1"
        
        if indexPath.row != 0
        {
            let dic = menuCategory[indexPath.row - 1]
            pageCounter = dic.cat_id
            
            
            lblTitle.text = dic.name
            
            self.placeArray = self.model.selectRecord(page: "1")
            
            let dic1 = placeArray.filter() { $0.cat_id.contains(pageCounter)}
            
            self.placeArray = dic1
            
            self.tableView.reloadData()
            self.markerSetOnMap()
            
        }
        else
        {
            lblTitle.text = "All Places"
            
            self.placeArray = self.model.selectRecord(page: "1")
            self.tableView.reloadData()
            self.markerSetOnMap()
        }
        
        if self.trailSubMenuContrain.constant == 5
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.trailSubMenuContrain.constant = -216
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    //========end table view delegae method=====
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if self.trailSubMenuContrain.constant == 5
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.trailSubMenuContrain.constant = -216
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        mapView.animate(toLocation: marker.position)
        return true
    }
    
    
    //MARK: Mapview Delegate method
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        let latitude: CLLocationDegrees = marker.position.latitude
        let longitude: CLLocationDegrees = marker.position.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = marker.title
        
        mapItem.openInMaps(launchOptions: options)
    }
    
    //end mapview delegate method============
    
    
    //MARK: markerSetOnMap
    /*========================================================================
     * Function Name: markerSetOnMap and create polyline
     * Function Purpose: marker set on map
     * CreateByAndDate : add by bunty 20-03-2017
     * =====================================================================*/
    func markerSetOnMap()  {
        
        mapView.clear()
        generateClusterItems()
        
    }
    //===========end markerSetOnMap method===================
    
    
    private func generateClusterItems() {
        
        clusterManager_ = GClusterManager(mapView: mapView, algorithm: NonHierarchicalDistanceBasedAlgorithm(), renderer: GDefaultClusterRenderer(mapView: mapView))
        mapView.delegate = clusterManager_
        
        var bounds : GMSCoordinateBounds = GMSCoordinateBounds()
        
        for index in 0..<placeArray.count {
            
            let dic = placeArray[index]
            
            let lat : CLLocationDegrees = CLLocationDegrees(dic.lat.doubleValue)
            let lng : CLLocationDegrees = CLLocationDegrees(dic.lng.doubleValue)
            
            let spot:Spot = generateSpot(lat: lat,lon: lng,index: index)
            clusterManager_.addItem(spot)
            
            let loc : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            bounds = bounds.includingCoordinate(loc)
        }
        clusterManager_.cluster()
        clusterManager_.delegate = self
        
        if curLat != 0 && curLong != 0
        {
            let lat : CLLocationDegrees = CLLocationDegrees(curLat)
            let lng : CLLocationDegrees = CLLocationDegrees(curLong)
            let loc : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            bounds = bounds.includingCoordinate(loc)
        }
        
        //map move on marker bounds
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.moveCamera(update)
        mapView.animate(with: update)
    }
    
    func generateSpot(lat:Double ,lon:Double,index: Int) -> Spot
    {
        let dic = placeArray[index]
        
        let marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.icon = #imageLiteral(resourceName: "ic_marker")
        
        marker.title = dic.name
       
        //marker.snippet = "\(index)"
        let spot : Spot = Spot()
        spot.location = marker.position;
        spot.marker = marker;
        return spot;
    }
}


