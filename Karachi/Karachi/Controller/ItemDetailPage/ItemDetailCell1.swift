//
//  ItemDetailCell1.swift
//  Karachi
//
//  Created by Bunty on 18/03/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

protocol ItemCell1Delegate {
    func ImageSliderOpen(imgArray : [InputSource] , initialIndex : Int)
}

class ItemDetailCell1: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    var delegate : ItemCell1Delegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgModel : [ImageModel] = []

    var imgArray : [InputSource] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK: Collection View delegate method
    //MARK: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgModel.count
    }
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        let imgPlace = cell.viewWithTag(1) as! UIImageView
        
        let dic = imgModel[indexPath.row]
        
        let urlIMG = URL(string: "\(baseImageURLPath)\(dic.name)")
        DispatchQueue.global().async {
            DispatchQueue.main.async {
               imgPlace.sd_setImage(with: urlIMG, placeholderImage: #imageLiteral(resourceName: "imgPlace"))
            
                self.imgArray.append(ImageSource(image: imgPlace.image!))
            }
        }
        
        return cell
    }
  
    //MARK: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.ImageSliderOpen(imgArray: imgArray,initialIndex:  indexPath.row)
    }
    
    //MARK: collectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  67 , height: 67)
    }
    //MARK: insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 2, right: 1)
    }
    //=======end delegate method==========
}
