//
//  SendingCell.swift
//  bumerang
//
//  Created by RMS on 2019/9/15.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class SendingCell: UITableViewCell {

    //@IBOutlet weak var ui_imvSender: UIImageView!
    
    @IBOutlet weak var ui_viewContent: UIView!
    @IBOutlet weak var ui_lblDate: UILabel!
    @IBOutlet weak var ui_lblMsg: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(chat:ChatRoomModel) {
        
        ui_lblDate.text = getMessageTimeFromTimeStamp(chat.time)
        ui_lblMsg.text = chat.strMsg
        
        
        ui_viewContent.clipsToBounds = false
        ui_viewContent.layer.cornerRadius = 10
        ui_viewContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]

       
    }

}
