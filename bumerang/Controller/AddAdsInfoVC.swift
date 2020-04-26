//
//  AddAdsInfoVC.swift
//  bumerang
//
//  Created by RMS on 10/25/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class AddAdsInfoVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapedNext(_ sender: Any) {
        self.gotoNavigationScreen("MyProductListVC", direction: .fromRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
