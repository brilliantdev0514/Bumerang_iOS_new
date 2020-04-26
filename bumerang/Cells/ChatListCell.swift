
import Foundation
import UIKit
import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol ChatListCellDelegate: AnyObject {
    func btnCloseTapped(cell: ChatListCell)
}

class ChatListCell: UICollectionViewCell {
    
    @IBOutlet weak var ui_avartarImg: UIImageView!
    @IBOutlet weak var ui_userLbl: UILabel!
    @IBOutlet weak var ui_contentLbl: UILabel!
    @IBOutlet weak var ui_timeLbl: UILabel!
    @IBOutlet weak var ui_unreadLbl: UILabel!
    @IBOutlet weak var ui_trash: UIButton!
    
    weak var delegate: ChatListCellDelegate?
    
    var entity : ChatListModel! {
        didSet{
            if entity.imgName.starts(with: "http") {
                ui_avartarImg.sd_setImage(with: URL(string: entity.imgName))
            }
            ui_avartarImg.cornerRadius = ui_avartarImg.bounds.height / 2
            ui_userLbl.text = entity.username
            ui_contentLbl.text = entity.contentStr
            ui_timeLbl.text = entity.reqDate
            ui_timeLbl.isHidden = true;
            ui_contentLbl.isHidden = true;
            if entity.unreadNum > 0 {
                
                ui_unreadLbl.text = "\(entity.unreadNum)"
            } else {
                ui_unreadLbl.isHidden = true
            }
        }
    }
    
    @IBAction func btnCloseTapped(sender: AnyObject) {
        
        delegate?.btnCloseTapped(cell: self)
    }
}

