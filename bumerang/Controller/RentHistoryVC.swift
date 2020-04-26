//
//  RentHistoryVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/11.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

class RentHistoryVC: BaseViewController {

    let rentColor = [0xA686FD, 0x99A9B3, 0xB9D8CD, 0x68A4CC, 0xE4B1B2]
    let rentStr = [
        "New\nRequest", "Acceped\n\nRequest",
        "Under\nRent", "Canceled\n\nRequest",
        "Finished\nRequest"
    ]
    
    var countCallApi = 0
    
    @IBOutlet weak var ui_rent_coll: UICollectionView!
    
    var rentData = [RentModel]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //self.navigationController?.navigationBar.isHidden = false
         
         loadRentData()
                
                setupMenuButton()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Geri", style:.plain, target:nil, action:nil)
    }
    
    func setupMenuButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"ic_filter"), for: .normal)
        menuBtn.addTarget(self, action: #selector(rightbuttonPressed), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func rightbuttonPressed() {
        
        //showToast("Share to fb")
    }
    
    @IBAction func gotoMaingpageVC(){
        self.navigationController?.popToRootViewController(animated: true)
//        self.gotoNavigationScreen("ChatListVC", direction: .fromLeft)
    }
    
    func loadRentData(){
        
//        self.showHUD()
        self.showALLoadingViewWithTitle(title: "Waiting", type: .messageWithIndicator )
        rentData.removeAll()
        
        
        if ShareData.user_info.user_type ==  Constants.userTypeAPI[1] {
            
            gotoRentHistoryOwner(1)
        } else if ShareData.user_info.user_type ==  Constants.userTypeAPI[0] {
            
            gotoRentHistoryUser(1)
        } else {
//            print(Defaults[.userType]!)
//            self.hideHUD()
            self.hideALLoadingView()
        }
    }

    func gotoRentHistoryOwner(_ pageNum: Int) {
        
        if pageNum == 1 {
            rentData.removeAll()
        }
//        ProductApiManager.getRentListOfOwner(pageNum: "\(pageNum)",  completion: {(isSuccess, data) in
//
////            self.hideHUD()
//            self.hideALLoadingView()
//
//            if (isSuccess) {
//                //product data
//
//                for one in JSON(data!).arrayValue {
//                    let oneRent = RentModel(dict: one)
//                    self.rentData.append(oneRent)
//                }
//
//            }
//            else {
//                if data == nil {
//                    if self.countCallApi < 2 {
//                        self.gotoRentHistoryOwner( pageNum)
//                        self.countCallApi += 1
//                    } else {
//                        self.countCallApi = 0
//                        self.showToast(R_EN.string.CONNECT_FAIL)
//
//                    }
//                }
//                else { self.showToast(JSON(data!).stringValue) }
//            }
//
//            self.ui_rent_coll.reloadData()
//        })
    }
    
    func gotoRentHistoryUser(_ pageNum: Int) {
        
        if pageNum == 1 {
            rentData.removeAll()
        }
        
//        ProductApiManager.getRentListOfUser(pageNum: "\(pageNum)",  completion: {(isSuccess, data) in
//            
//            self.hideALLoadingView()
//            
//            if (isSuccess) {
//                //product data
//                
//                for one in JSON(data!).arrayValue {
//                    let oneRent = RentModel(dict: one)
//                    self.rentData.append(oneRent)
//                }
//                
//            }
//            else {
//                if data == nil {
//                    if data == nil {
//                        if self.countCallApi < 2 {
//                            self.gotoRentHistoryOwner( pageNum)
//                            self.countCallApi += 1
//                        } else {
//                            self.countCallApi = 0
//                            self.showToast(R_EN.string.CONNECT_FAIL)
//                            
//                        }
//                    }
//                }
//                else { self.showToast(JSON(data!).stringValue) }
//            }
//            
//            self.ui_rent_coll.reloadData()
//        })
    }
    
    @IBAction func onClickPluse(_ sender: Any) {
        self.gotoNavigationScreen("CatagorySelectVC", direction: .fromTop)
    }
    
    @IBAction func onClickChart(_ sender: Any) {
        self.gotoTabVC("MainpageAfterNav")
    }
    
    @IBAction func onClickChat(_ sender: Any) {
//        self.gotoNavigationScreen("ChatListVC", direction: .fromLeft)
        self.gotoTabVC("ChatListNav")
    }
    
    @IBAction func onClickRend(_ sender: Any) {
        
        loadRentData()
    }
    
    @IBAction func onClickMyProfile(_ sender: Any) {     //  self.gotoNavigationScreen("UserInfoVC", direction: .fromLeft)
        self.navigationController?.navigationBar.isHidden = true
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
    
}

extension RentHistoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ShareData.user_info.user_type ==  Constants.userTypeAPI[0] {
            
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "RentDetailOfUserVC") as! RentDetailOfUserVC
            toVC.oneRentData = rentData[indexPath.row]
            self.navigationController?.pushViewController(toVC, animated: true)
        } else if ShareData.user_info.user_type == Constants.userTypeAPI[1] {
            
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "RentDetailOfUserVC") as! RentDetailOfUserVC
            toVC.oneRentData = rentData[indexPath.row]
            self.navigationController?.pushViewController(toVC, animated: true)
            
        } else {
            print("other")
        }
        
//        for i in 0 ..< rentData.count {
//            let state = (i == curCatagory ? true : false)
//            catagoryData[i].catagoryState = state
//        }
//
//        ui_rent_coll.reloadData()
        
    }
    
}

extension RentHistoryVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return rentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RendHistoryCell", for: indexPath) as! RendHistoryCell
        cell.entity = rentData[indexPath.row]
        
        return cell
        
    }
}
extension RentHistoryVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        let h : CGFloat = 120
        return CGSize(width: w, height: h)
    }
}
