//
//  Congratulate.swift
//  bumerang
//
//  Created by Billiard ball on 05.02.2020.
//  Copyright © 2020 RMS. All rights reserved.
//

import UIKit

class Congratulate: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toMainVC(_ sender: Any) {
        gotoTabVC("MainpageAfterNav")
        
    }
    func gotoTabVC (_ nameNavVC: String) {
//        self.dismiss(animated: true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MainpageAfterNav") as! UINavigationController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
}
