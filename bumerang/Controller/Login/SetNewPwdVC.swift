//
//  SetNewPwdVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/9.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

class SetNewPwdVC: BaseViewController {
    var countCallApi = 0
    var userId = ""

    @IBOutlet weak var ui_viewMain: UIView!
    @IBOutlet weak var ui_newPwd: CustomTextField!
    @IBOutlet weak var ui_confPwd: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTaped(sender:))))
        
        ui_viewMain.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func onClickChagePwd(_ sender: Any) {
        
        let newPwd = ui_newPwd.text!
        let confPwd = ui_confPwd.text!
        
        if newPwd.isEmpty {
            showToast(R_EN.string.INPUT_NEW_PWD, duration: 2, position: .center)
            return
        } else if confPwd.isEmpty {
            showToast(R_EN.string.INPUT_CONFIRM_PWD, duration: 2, position: .center)
            return
        } else if newPwd != confPwd {
            showToast(R_EN.string.INVAILD_PWD, duration: 2, position: .center)
            return
        } else {
            callSetNewPwdAPI(newPwd)
            
        }
    }
    
    func callSetNewPwdAPI(_ newPwd : String) {
        self.showALLoadingViewWithTitle(title: "Requesting now", type: .messageWithIndicator )
        // call api
        
    }
    
    @objc func handleTaped(sender: UITapGestureRecognizer){
        self.hideMe()
    }
    @IBAction func onTapedClose(_ sender: Any) {
        hideMe()
    }
    
    func hideMe(){
        if signinVC != nil {
            
            ui_newPwd.text = ""
            ui_confPwd.text = ""
            
            ui_newPwd.endEditing(true)
            ui_confPwd.endEditing(true)
            
            signinVC.hideSetNewPwdVC()
        } else {
            print("error")
        }
    }
}
