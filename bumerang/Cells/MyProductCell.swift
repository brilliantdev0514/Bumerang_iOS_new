//
//  MyProductCell.swift
//  bumerang
//
//  Created by RMS on 10/25/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

class MyProductCell: UICollectionViewCell {

    @IBOutlet weak var ui_imgProd: UIImageView!
    @IBOutlet weak var ui_lblTitle: UILabel!
    @IBOutlet weak var ui_lblPrice: UILabel!
    @IBOutlet weak var ui_lblUpdate: UILabel!
    @IBOutlet weak var ui_lblCreate: UILabel!
    @IBOutlet weak var ui_lblState: UILabel!
    
    var entity : ProductModels! {
        didSet {
            guard entity.image_url != nil else {return}
            if entity.image_url.starts(with: "http") {
                ui_imgProd.sd_setImage(with: URL(string: entity.image_url)) { (image, error, cache, urls) in
                    if (error != nil) {
                        // Failed to load image
                        self.ui_imgProd.image = UIImage(named: self.entity.placeHolerImage)
                    } else {
                        // Successful in loading image
                        self.ui_imgProd.image = image
                    }
                }
            } else {
                ui_imgProd.image = UIImage(named: entity.placeHolerImage)
            }
            
            
            ui_lblTitle.text = entity.title
            ui_lblPrice.text = "\(entity.price)/\(entity.date_unit)"
//            ui_lblUpdate.text = getStringFormDate(date: entity!.updated_at, format: "dd/MM/yyyy")
//            
//            ui_lblCreate.text = getStringFormDate(date: entity!.created_at, format: "dd/MM/yyyy")
            
            
//            ui_lblState.text = entity.adsState
//            if entity.adsState == "Yes" {
//
//                ui_lblState.backgroundColor = UIColor(named: "cata_9_cam")
//            } else {
//                ui_lblState.backgroundColor = UIColor(named: "productLbl")
//            }
            
        }
    }
}
