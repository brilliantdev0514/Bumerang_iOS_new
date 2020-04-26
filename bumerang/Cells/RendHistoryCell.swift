//
//  RendHistoryCell.swift
//  bumerang
//
//  Created by RMS on 2019/9/11.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Photos

class RendHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var main_img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var req_date: UILabel!
    @IBOutlet weak var ui_reqState_lbl: UILabel!
    
    var entity : RentModel! {
        didSet{
//            if let img = UIImage(named: entity.productImg) {
//                main_img.image = img
//            }
            main_img.sd_setImage(with: URL(string: entity.prodImage))
            title_lbl.text = entity.prodTitle
            price_lbl.text = Constants.currencyUnit + "\(entity.prodPriceVal)/" + entity.prodPriceType
            
            let reqDateVal = getDateFormString(strDate: entity.rentRequestDate, format: "yyyy-MM-dd'T'HH:mm:ss")
            
            req_date.text = "Request Date : " + getStringFormDate(date: reqDateVal, format: "dd/MM/yyyy")
            
            ui_reqState_lbl.text = entity.rentState
            ui_reqState_lbl.backgroundColor = UIColor(rgb: entity.stateBackColor)
            ui_reqState_lbl.textColor = UIColor(rgb: entity.stateTxtColor)
            ui_reqState_lbl.cornerRadius = ui_reqState_lbl.bounds.height / 2
        }
    }
}
