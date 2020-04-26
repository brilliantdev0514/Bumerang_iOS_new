//
//  IntroCell.swift
//  bumerang
//
//  Created by RMS on 2019/9/4.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

class IntroCell: UICollectionViewCell {
    
    @IBOutlet weak var img_splach: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var txt_content: UITextView!
    
    var entity : IntroModel! {
        
        didSet{
            
            if let img = UIImage(named: entity.imgName) {
                img_splach.image = img
            }
            lbl_name.text = entity.topicStr
            txt_content.text = entity.contentStr
        }
    }
    
}
