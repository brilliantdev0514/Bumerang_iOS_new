
import Foundation
import UIKit
import SDWebImage
import Photos



class MainpageCatCell: UICollectionViewCell {
    
    @IBOutlet weak var ui_topView: UIView!
    @IBOutlet weak var ui_topViewSelected: UIView!
    @IBOutlet weak var ui_catagoryImg: UIImageView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layoutIfNeede"d(self)
    }
    
    var entity : MainCatagoryModel! {
        didSet{
            if let img = UIImage(named: entity.catatoryImg) {
                ui_catagoryImg.image = img
            }
            ui_topView.backgroundColor = UIColor(rgb: entity!.catagoryColor!)
            ui_topViewSelected.backgroundColor = UIColor(rgb: entity!.catagoryColor!)
            
            if entity.catagoryState {
                
                ui_topViewSelected.isHidden = false
            } else {
                ui_topViewSelected.isHidden = true
            }
            
            ui_topView.cornerRadius = ui_topView.height / 2
            ui_topViewSelected.cornerRadius = ui_topViewSelected.height / 2
            
         
        }
    }
}

class MainpageAdsCell: UICollectionViewCell {

    @IBOutlet weak var ui_imgMain: UIImageView!
    @IBOutlet weak var ui_lblDescription: UILabel!
    
    var entity : MainAdsModel! {

        didSet{
            if entity.adsImg!.starts(with: "http") {
                
                ui_imgMain.sd_imageIndicator = SDWebImageActivityIndicator.gray
                ui_imgMain.sd_setImage(with: URL(string: entity.adsImg!)) { (image, error, cache, urls) in
                    if (error != nil) {
                        // Failed to load image
                        self.ui_imgMain.image = UIImage(named: self.entity.placeHolerImage)
                    } else {
                        // Successful in loading image
                        self.ui_imgMain.image = image
                    }
                }
            } else {
                ui_imgMain.image = UIImage(named: entity.adsImg!)
            }
            
            ui_lblDescription.text = entity.adsTitle
        }
    }
}

class MainpageFilterCell: UICollectionViewCell {
    
 //   @IBOutlet weak var ui_lblFilter: UILabel!
    @IBOutlet weak var ui_dropdownFilter: DropDown!
    
    var dropDelegate : DropdownDelegate!
    
    
    @IBOutlet weak var filterlogo: UIImageView!
    
    
    
    
    
    var entity : MainFilterModel! {
        
        didSet{
            
           // ui_lblFilter.text = ""
            
        //    filterlogo.image = entity.logo
            ui_dropdownFilter.optionArray = entity.filterLbls
            ui_dropdownFilter.optionIds = entity.filterIDs
            ui_dropdownFilter.text = entity.titleLbl
            ui_dropdownFilter.isSearchEnable = false
            ui_dropdownFilter.checkMarkEnabled = false
            ui_dropdownFilter.layer.cornerRadius = 20
            ui_dropdownFilter.layer.borderColor = #colorLiteral(red: 0.8507481217, green: 0.3468235731, blue: 0.3539260924, alpha: 1)
             ui_dropdownFilter.layer.borderWidth = 3
            
            
            ui_dropdownFilter.didSelect{(selectedText , index , id) in
                
                self.dropDelegate.onSelect(categoryID: self.tag, dropIndex: self.ui_dropdownFilter.tag, selectedVal: selectedText)
            }
        }
    }
}
    
class MainpageProductCell: UICollectionViewCell {
    
    @IBOutlet weak var ui_img_main: UIImageView!
    @IBOutlet weak var ui_img_rent: UIImageView!
    @IBOutlet weak var ui_lblUsertype: UILabel!
    @IBOutlet weak var ui_lblDeposit: UILabel!
    @IBOutlet weak var ui_lblTitle: UILabel!
    @IBOutlet weak var ui_lblPrice: UILabel!
    
    var entity : ProductModels! {
        
        didSet{
           guard entity.image_url != nil else {
                return
            }
            if entity.image_url.starts(with: "https") {
                
                  let str = entity.image_url.components(separatedBy: ",")
                
                
                ui_img_main.sd_setImage(with: URL(string: str[0])) { (image, error, cache, urls) in
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
            
//            ui_img_rent.isHidden = !(entity!.rental_status != nil)
            ui_img_rent.isHidden = true
            
            if entity.deposit == "Evet" { ui_lblDeposit.isHidden = false }
            else { ui_lblDeposit.isHidden = true }
//            ui_lblUsertype.visiblity(gone: true)
//
//            if entity.memberShipState != ""
//            {
//
//                ui_lblUsertype.visiblity(gone: false)
//
//                ui_lblUsertype.text = Constants.userTypeAPI[1]
//            }
            if entity.memberShipState == "" {
//                ui_lblUsertype.visiblity(gone: true)
//                ui_lblUsertype.isHidden = true
//                ui_lblDeposit.visiblity(gone: true)
//                ui_lblDeposit.isHidden = true
                
                ui_lblUsertype.gone()
            }
        
            ui_lblUsertype.text = "Kurumsal"
            
            ui_lblTitle.text = entity.title
            
            ui_lblPrice.text = "₺" + entity.price + "/" + entity.date_unit
            
        }
    }
}
protocol DropdownDelegate {
    
    func onSelect(categoryID: Int, dropIndex: Int, selectedVal: String)
}
