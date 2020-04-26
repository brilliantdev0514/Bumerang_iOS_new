//
//  SelCategoryBusinessVC.swift
//  bumerang
//
//  Created by RMS on 2019/10/8.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class SelCategoryBusinessVC: BaseViewController {
    
    
    @IBOutlet weak var sv: UIStackView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sv.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        sv.layer.borderWidth = 1
        

    }
    @IBAction func onTapedClose(_ sender: Any) {
        self.gotoMainBeforeVC()
//         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapedCategory(_ sender: UIButton) {
        
        let str = Constants.categoryName[sender.tag]
        
        let alert = UIAlertController(title: str, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R_EN.string.CANCEL, style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: R_EN.string.OK, style: .default, handler : {(action) -> Void in
                        
            selectedCategoryID = sender.tag
//            print("-------- \(selectedCategoryID)")
            staticValue.ownerType = Constants.categoryName[sender.tag]
             let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SelectMembershipVC") as! SelectMembershipVC
                   
                   self.modalPresentationStyle = .fullScreen
                  // self.navigationController?.pushViewController(toVC, animated: true)
                   self.present(toVC, animated: true, completion: nil)
        }))
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
        
        
    }
    
}
