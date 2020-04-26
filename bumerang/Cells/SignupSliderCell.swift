//
//  SignupSliderCell.swift
//  bumerang
//
//  Created by RMS on 2019/9/4.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

class SignupSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var img_splach: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_content: UITextView!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
//        self.layer.borderWidth = 10
//        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
//    }
//    
    var entity : IntroModel! {
        
        didSet{
            
            if let img = UIImage(named: entity.imgName) {
                img_splach.image = img
            }
            lbl_title.text = entity.topicStr
            txt_content.text = entity.contentStr
        }
    }
}
