//
//  ReceivingCell.swift
//  bumerang
//
//  Created by RMS on 2019/9/15.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class ReceivingCell: UITableViewCell {

    @IBOutlet weak var ui_imvSender: UIImageView!
    
    @IBOutlet weak var ui_viewTxt: UIView!
    @IBOutlet weak var ui_lblUsernameDate: UILabel!
    @IBOutlet weak var ui_lblMsg: UILabel!
    
    var photoURL = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(chat:ChatRoomModel) {
        photoURL = chat.receiver_photo
        if photoURL.starts(with: "http") {
            ui_imvSender.sd_setImage(with: URL(string: photoURL))
        }
        ui_imvSender.cornerRadius = ui_imvSender.bounds.height / 2
//        ui_lblUsernameDate.text = ShareData.user_info.first_name + " " + ShareData.user_info.last_name + "," + getMessageTimeFromTimeStamp(chat.time)
        ui_lblUsernameDate.text = getMessageTimeFromTimeStamp(chat.time)
        ui_lblMsg.text = chat.strMsg
               
        ui_viewTxt.clipsToBounds = false
        ui_viewTxt.layer.cornerRadius = 10
        ui_viewTxt.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

}
