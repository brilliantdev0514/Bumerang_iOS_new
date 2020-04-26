//
//  UserinfoCells.swift
//  bumerang
//
//  Created by RMS on 2019/9/13.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class UserinfoProductCell: UICollectionViewCell {
    
    @IBOutlet weak var ui_img_main: UIImageView!
    @IBOutlet weak var ui_img_rent: UIImageView!
    @IBOutlet weak var ui_lbl_Top1: UILabel!
    @IBOutlet weak var ui_lbl_top2: UILabel!
    @IBOutlet weak var ui_lbl_mid: UILabel!
    @IBOutlet weak var ui_lbl_bottom: UILabel!
    
    var entity : ProductModels! {
        didSet {
            guard entity.image_url != nil else {
                return
            }
            if entity.image_url.starts(with: "http") {
                ui_img_main.sd_setImage(with: URL(string: entity.image_url)) { (image, error, cache, urls) in
                    if (error != nil) {
                        // Failed to load image
                        self.ui_img_main.image = UIImage(named: self.entity.placeHolerImage)
                    } else {
                        // Successful in loading image
                        self.ui_img_main.image = image
                    }
                }
            } else {
                ui_img_main.image = UIImage(named: entity.placeHolerImage)
            }
            
            ui_img_rent.isHidden = (entity.rental_status != nil)
            
            if !entity.title.isEmpty {
                ui_lbl_Top1.text = entity.title
                ui_lbl_top2.isHidden = true
            } else {
                ui_lbl_Top1.isHidden = false
            }
            ui_lbl_Top1.text = entity.title
            ui_lbl_top2.text = entity.furbished
            ui_lbl_mid.text = entity.fuel_type
            ui_lbl_bottom.text = "\(entity.price ?? "")/\(entity.date_unit ?? "")"
        }
    }
    
}
