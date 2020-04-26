//
//  RentDetailOfUserVC.swift
//  bumerang
//
//  Created by RMS on 2019/10/3.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import Cosmos

class RentDetailOfUserVC: BaseViewController {
    
    

    @IBOutlet weak var ui_imgProduct: UIImageView!
    @IBOutlet weak var ui_lblProductTitle: UILabel!
    @IBOutlet weak var ui_lblProductPrice: UILabel!
    
    @IBOutlet weak var ui_imgAvatar: UIImageView!
    @IBOutlet weak var ui_lblUsername: UILabel!
    @IBOutlet weak var ui_lblReviewNum: UILabel!
    @IBOutlet weak var ui_lblAddr: UILabel!
    @IBOutlet weak var ui_imgMail: UIImageView!
    @IBOutlet weak var ui_lblMailTxt: UILabel!
    @IBOutlet weak var ui_imgPhone: UIImageView!
    @IBOutlet weak var ui_lblPhoneNum: UILabel!
    @IBOutlet weak var ui_imgGmail: UIImageView!
    @IBOutlet weak var ui_imgFacebook: UIImageView!
    
    @IBOutlet weak var ui_viewRatingStar: CosmosView!
    @IBOutlet weak var ui_lblRatingVal: UILabel!
    @IBOutlet weak var ui_lblTotalDay: UILabel!
    @IBOutlet weak var ui_lblFromDate: UILabel!
    @IBOutlet weak var ui_lblToDate: UILabel!
    @IBOutlet weak var ui_lblRentVal: UILabel!
    
    
    var oneRentData : RentModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard oneRentData != nil else {
            return
        }
        
        ui_viewRatingStar.isExclusiveTouch = false
        ui_viewRatingStar.settings.updateOnTouch = false
        
        setAllInfos()
    }
    
    
    
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    
    
    }
    
    

    @IBAction func onTapedReview(_ sender: Any) {
        print("onTapedReview")
    }
    
    @IBAction func onTapedCancel(_ sender: Any) {
        showToast("cancel", duration: 1, position: .center)
    }
    
    @IBAction func onTapedAccept(_ sender: Any) {
        showToast("accept", duration: 1, position: .center)
    }
    
//    func formatValue(_ value: Double) -> String {
//        return String(format: "%.1f", value)
//    }
//
//    private func didTouchCosmos(_ rating: Double) {
//        ui_lblRatingVal.text = formatValue(rating)
//    }
//
//    private func didFinishTouchingCosmos(_ rating: Double) {
//        self.ui_lblRatingVal.text = formatValue(rating)
    
    
    
    
//    }
    
    func setAllInfos() {
        
        ui_imgProduct.sd_setImage(with: URL(string: oneRentData!.prodImage), completed: nil)
        ui_lblProductTitle.text = oneRentData!.prodTitle
        ui_lblProductPrice.text = Constants.currencyUnit + "\(oneRentData!.prodPriceVal)/\(oneRentData!.prodPriceType)"
        
        ui_imgAvatar.sd_setImage(with: URL(string: oneRentData!.ownerAvatar), completed: nil)
        ui_lblUsername.text = oneRentData!.ownerFistName + " " + oneRentData!.ownerLastName
        ui_lblReviewNum.text = "\(oneRentData!.ownerReviewNum ) reviews"
        ui_lblAddr.text = oneRentData!.ownerAddr
        ui_lblMailTxt.text = oneRentData!.ownerEmail
        if oneRentData!.ownerEmail.isEmpty {
            ui_imgMail.image = UIImage(named: "ic_mail_grey")
        } else {
            ui_imgMail.image = UIImage(named: "ic_mail_blue")
        }
        
        ui_lblPhoneNum.text = oneRentData!.ownerphoneNum
        if oneRentData!.ownerphoneNum.isEmpty {
            ui_imgPhone.image = UIImage(named: "ic_phone_grey")
        } else {
            ui_imgPhone.image = UIImage(named: "ic_phone_blue")
        }
        
        if oneRentData!.ownerGmail.isEmpty {
            ui_imgGmail.image = UIImage(named: "ic_google_unverified")
        } else {
            ui_imgGmail.image = UIImage(named: "ic_google_verified")
        }
        
        if oneRentData!.ownerFacebook.isEmpty {
            ui_imgFacebook.image = UIImage(named: "ic_facebook_unverified")
        } else {
            ui_imgFacebook.image = UIImage(named: "ic_facebook_verified")
        }
        
        ui_viewRatingStar.rating = Double(oneRentData!.ownerScore)
     //   ui_lblRatingVal.text = "\(oneRentData!.ownerScore)"
        
        let startDay = getDateFormString(strDate: oneRentData!.rentStartDate, format: "yyyy-MM-dd'T'HH:mm:ss")
        let endDay = getDateFormString(strDate: oneRentData!.rentEndDate, format: "yyyy-MM-dd'T'HH:mm:ss")
        
        let difference = Calendar.current.dateComponents([.day], from: startDay, to: endDay)
        let totalDays = difference.day! + 1
        
        ui_lblTotalDay.text = "\(totalDays) days"
        ui_lblFromDate.text = getStringFormDate(date: startDay, format: "dd/MM/yyyy")
        ui_lblToDate.text = getStringFormDate(date: endDay, format: "dd/MM/yyyy")
    }
    
}
