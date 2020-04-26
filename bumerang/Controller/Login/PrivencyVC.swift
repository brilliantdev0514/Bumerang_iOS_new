
//
//  PrivencyVC.swift
//  bumerang
//
//  Created by RMS on 10/27/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class PrivencyVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func tapToDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
