//
//  requestDetails.swift
//  bumerang
//
//  Created by mac on 24/12/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class requestDetails: BaseViewController {
    
    @IBOutlet weak var v1: UIView!
    
    @IBOutlet weak var b1: UIButton!
    
    @IBOutlet weak var b2: UIButton!
    
    
    
    
    
    @IBOutlet weak var backbutton: UIButton!
    
    
    let selectedBGcolour = #colorLiteral(red: 0.937254902, green: 0.337254902, blue: 0.3254901961, alpha: 1)
      
      
      let nonBGcolour = #colorLiteral(red: 0.9372549057, green: 0.3353271826, blue: 0.3251749583, alpha: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b1.backgroundColor = selectedBGcolour
        b2.backgroundColor = nonBGcolour
        
        
        
        b1.setTitleColor(  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , for: .normal)

        b2.setTitleColor(UIColor.darkGray, for: .normal)
        
        
        b1.clipsToBounds = true
        b2.clipsToBounds = true
        v1.clipsToBounds = true
        
        b1.cornerRadius = b1.height/2
        b2.cornerRadius = b2.height/2
        v1.cornerRadius = v1.height/2
        
        v1.borderColor = UIColor.black
        v1.borderWidth = 1
        
        b1.setTitleColor(UIColor.white, for: .normal)
        
        b2.setTitleColor(UIColor.gray, for: .normal)
        
        
        
        
        
        
       
    }
    
    
    @IBAction func onClickPluse(_ sender: Any) {
           self.gotoNavigationScreen("CatagorySelectVC", direction: .fromLeft)
       }
       
       @IBAction func onClickChart(_ sender: Any) {
           
           self.gotoTabVC("MainpageAfterNav")
       }
       
       @IBAction func onClickChat(_ sender: Any) {
           self.gotoTabVC("ChatListNav")

       }
       
       @IBAction func onClickRend(_ sender: Any) {
           self.gotoTabVC("RentHistoryNav")

       }
       
       @IBAction func onClickMyProfile(_ sender: Any) {
        if (ShareData.user_info.membership == "1") {
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoVC") as! BusinessInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        } else {
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "StandardInfoVC") as! StandardInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        }
       }
       
    
    
    
    
    @IBAction func clickIn(_ sender: UIButton) {
        
        b2.backgroundColor = nonBGcolour
        
        b1.backgroundColor = selectedBGcolour
        
        b2.setTitleColor(UIColor.white, for: .normal)
       
        b1.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
    }
    
    
    
  
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
    @IBAction func clickOut(_ sender: Any) {
        
        
        b1.backgroundColor = nonBGcolour
               
               b2.backgroundColor = selectedBGcolour
               
               b1.setTitleColor(UIColor.white, for: .normal)
              
               b2.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        
    }
    
  
}

extension requestDetails: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! requestCell
        
        
        
        cell.earning.cornerRadius = cell.earning.height/2
        cell.time.cornerRadius = cell.time.height/2
        
        cell.requesticon.cornerRadius = 5
        
        cell.v1.borderWidth = 2
        cell.v1.borderColor = #colorLiteral(red: 0.937254902, green: 0.337254902, blue: 0.3254901961, alpha: 1)
        
        cell.v1.cornerRadius = 5
        
        
        
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let toVC = self.storyboard?.instantiateViewController(withIdentifier: "RentDetailOfUserVC") as! RentDetailOfUserVC
                  self.navigationController?.pushViewController(toVC, animated: true)
        
        
    }
   
    
    
    
}
