//
//  RecoveryEmailVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/8.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecoveryEmailVC: BaseViewController {

    @IBOutlet weak var ui_mainView: UIView!
    @IBOutlet weak var ui_emailTxt: CustomTextField!
    var countCallApi = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTaped(sender:))))
        
        ui_mainView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func onClickSend(_ sender: Any) {
        
        let mailTxt = ui_emailTxt.text!
        if mailTxt.isEmpty {
            showToast(R_EN.string.ENTER_MAIL_PHONE, duration: 2, position: .center)
            return
        }
    }
    
    @IBAction func onTapedClose(_ sender: Any) {
        hideMe()
    }
    @objc func handleTaped(sender: UITapGestureRecognizer){
        hideMe()
    }
    
    func hideMe() {
        
        self.ui_emailTxt.endEditing(true)
        ui_emailTxt.endEditing(true)
        
        if signinVC != nil {
            ui_emailTxt.text = ""
            signinVC.hideRecoveryEmailVC(true)
        } else {
            print("error")
        }
    }
}
