//
//  TermsVC.swift
//  bumerang
//
//  Created by RMS on 10/23/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class TermsVC: BaseViewController {

    var ui_texTerms: UITextView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //ui_texTerms.text = terms
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func tapToDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
