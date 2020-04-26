//
//  BeforeSignupVC.swift
//  bumerang
//
//  Created by Billiard ball on 05.02.2020.
//  Copyright © 2020 RMS. All rights reserved.
//

import UIKit

class BeforeSignupVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didSelectCloseBtn(_ sender: Any) {
//        let toSignUP = storyboard?.instantiateViewController(withIdentifier: "MainpageVC") as! MainpageVC
//        self.modalPresentationStyle = .fullScreen
//        self.present(toSignUP, animated: true, completion: nil)
        self.gotoTabVC("MainpageAfterNav")
    }
    @IBAction func didCancelBtn(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}
