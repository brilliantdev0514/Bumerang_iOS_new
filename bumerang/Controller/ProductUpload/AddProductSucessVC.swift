//
//  AddProductSucessVC.swift
//  bumerang
//
//  Created by mac on 2/17/20.
//  Copyright © 2020 RMS. All rights reserved.
//

import UIKit

protocol AddProductSucessVCDelegate:class {
    func myVCDidFinish()
}

class AddProductSucessVC: UIViewController {

    weak var delegate: AddProductSucessVCDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didSelectCloseBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.delegate?.myVCDidFinish()
        }
    }
    
    @IBAction func didCancelBtn(_ sender: Any){
        
        self.dismiss(animated: true) {
            
            self.delegate?.myVCDidFinish()
        }
        //self.dismiss(animated: true, completion: nil)
    }
}
