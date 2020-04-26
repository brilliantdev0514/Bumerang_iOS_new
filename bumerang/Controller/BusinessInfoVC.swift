//
//  UserProfileVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/13.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
class BusinessInfoVC: BaseViewController {

    var oneProduct : ProductModels? = nil
        var productUser : Users? = nil
        
        @IBOutlet weak var ui_avatarView: UIView!
        @IBOutlet weak var ui_avatarImg: UIImageView!
        @IBOutlet weak var ui_lblUsername: UILabel!
       
        @IBOutlet weak var ui_productLbl: UILabel!
        @IBOutlet weak var ui_product_coll: UICollectionView!
        @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var messageButton: UIButton!
        @IBOutlet weak var settingButton: UIButton!
        
    @IBOutlet weak var report_user: UIButton!
    
        var productData = [ProductModels]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //MARK:- read user info from firebase
            
            self.showALLoadingViewWithTitle(title: "Loading Profile", type: .messageWithIndicator )
            
            var uid : String = ""
            if oneProduct != nil {
                
                uid = oneProduct!.owner_id
                if uid == ShareData.user_info.userId {
                    messageButton.removeFromSuperview()
                    report_user.isHidden = true
                    setupMenuButton()
                } else {
                    messageButton.cornerRadius = messageButton.bounds.height/2
                    settingButton.isHidden = true
                }
            } else {
                messageButton.removeFromSuperview()
                
                uid = Auth.auth().currentUser!.uid
                if uid != "" {
                    messageButton.removeFromSuperview()
                    report_user.isHidden = true
                    setupMenuButton()
                }
            }
            
            ShareData.dbUserRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                      // Get user value
                        
                        if !snapshot.exists() {
                            // handle data not found
                            self.hideALLoadingView()
                            return
                        }
                        let userData = snapshot.value as! [String: String]
            //          Users user = Users.init(dict: value)
                        self.productUser = Users.init(dict: userData)!
                        
                        self.loadProductData()
                        self.ui_lblUsername.text =  self.productUser!.first_name + " " +  self.productUser!.last_name
                        if self.productUser!.avatarUrl != "" {
                            self.ui_avatarImg.sd_setImage(with: URL(string: self.productUser!.avatarUrl), placeholderImage: UIImage.init(named: "ic_avatar"))
                        }
                        
                      // ...
                      }) { (error) in
                        print(error.localizedDescription)
                        self.hideALLoadingView()
                    }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    //        self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Geri", style:.plain, target:nil, action:nil)
        }
        
        func loadProductData(){
            
            ProductData.dbProRef.observe(DataEventType.value, with: { (snapshot) in
                                self.hideALLoadingView()
                                self.productData.removeAll()
                                let productList = snapshot.children.allObjects as! [DataSnapshot]
                                for data in productList{
                                    if let data = data.value as? [String: Any] {
                                        
                                        let oneProductModel = ProductModels.init(dictPro: data)
                                        if oneProductModel?.owner_id == self.productUser!.userId {

                                            self.productData.append(oneProductModel!)
                                        }
                                    }
                                }
                                //self.ui_productLbl.text = "Product(\(self.productData.count))"
                
                self.collectionHeightConstraint.constant = CGFloat(220 * ceil(Float(self.productData.count) / 2.0)) + 20.0
                                self.ui_product_coll.reloadData()
                                self.ui_product_coll.layoutIfNeeded()
                   
                            })
        }
    //MARK:- report user function
    @IBAction func didClickReportUserBtn(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Rapor / Engelle", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Rapor", style: .default, handler: {(action) -> Void in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let current_date = dateFormatter.string(from: date)
            let uid = Auth.auth().currentUser!.uid
            let other_id = self.oneProduct!.owner_id
            Database.database().reference().child("ReportedUsers").child(other_id!).child(uid).setValue(current_date)
            self.reportConfirm()
                       
        }))
        alert.addAction(UIAlertAction(title: "Engelle", style: .default, handler: {(action) -> Void in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let current_date = dateFormatter.string(from: date)
            let my_ID = Auth.auth().currentUser!.uid
            let other_ID = self.oneProduct!.owner_id
            Database.database().reference().child("BlockedUsers").child(other_ID! + "_" + my_ID).setValue(current_date)
            self.blockConfirm()
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    func reportConfirm() {
        let alert = UIAlertController(title: "", message: "Kullanıcıyı bildirdiniz, gerekli işlemi yapacağız", preferredStyle: .actionSheet)
       
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func blockConfirm() {
        let alert = UIAlertController(title: "", message: "Kullanıcıyı engellediniz, bu kullanıcıdan asla mesaj göndermeyecek veya almayacaksınız", preferredStyle: .actionSheet)
        
         alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
    }
    
        

        
        func setupMenuButton() {
      
            //right button
            let menuRightBtn = UIButton(type: .custom)
            menuRightBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
            menuRightBtn.setImage(UIImage(named:"ic_setting"), for: .normal)
            menuRightBtn.addTarget(self, action: #selector(rightbuttonPressed), for: .touchUpInside)
            
            let menuBarItem = UIBarButtonItem(customView: menuRightBtn)
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
            currWidth?.isActive = true
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
            currHeight?.isActive = true
            self.navigationItem.rightBarButtonItem = menuBarItem
        }
        
        @objc func rightbuttonPressed() {
            self.gotoNavigationScreen("UserProfileVC", direction: .fromRight)
        }
        
        @IBAction func rightpressed(){
            let toVC = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
            toVC.modalPresentationStyle = .overFullScreen
            self.present(toVC, animated: true, completion: nil)
        }
        
        @IBAction func leftbuttonPressed() {
            self.gotoTabVC("MainpageAfterNav")
        }
        
        @IBAction func onClickChat(_ sender: Any) {
            
            if ShareData.user_info.userId == oneProduct?.owner_id {
                
                showToast(R_EN.string.CHAT_REQUEST_FAIL_USER, duration: 2, position: .center)
                return
            } else if staticValue.registerStatus == "0" {
                
                showToast(R_EN.string.CHAT_REQUEST_FAIL_LOGIN, duration: 2, position: .center)
                
            } else {
                Database.database().reference().child("BlockedUsers").observeSingleEvent(of: .value, with: { (snapshot) in
                                          // Get user value
                                            if !snapshot.exists() {
                                                // handle data not found
                                                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                                                toVC.receiveUserId = self.oneProduct!.owner_id
                                                self.modalPresentationStyle = .fullScreen
                                                self.navigationController?.pushViewController(toVC, animated: true)
                                                return
                                            }
                var groupNames = ""
                                            for group in snapshot.children {
                                                groupNames.append((group as AnyObject).key)
                                            }
                                            print(groupNames)
                let uid = Auth.auth().currentUser!.uid
                if (groupNames.contains(uid + "_" + self.oneProduct!.owner_id) ||
                    groupNames.contains(self.oneProduct!.owner_id + "_" + uid)) {
                    self.showToast("Kullanıcı engellendi. Yaşadığınız sorunlardan dolayı özür dileriz")
                } else {
                    let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                    toVC.receiveUserId = self.oneProduct!.owner_id
                    self.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(toVC, animated: true)
                }
                                          }) { (error) in
                                            print(error.localizedDescription)
                                        }
            }
            
        }
}

extension BusinessInfoVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.ui_product_coll {self.gotoProdauctdetailpageVC(productNum: indexPath.row)
                       
                        
                     //   let toVC = self.storyboard?.instantiateViewController(withIdentifier: "profileuploadimageDetails") as! profileuploadimageDetails
                                 
                             //    self.navigationController?.pushViewController(toVC, animated: true)
                        
                    }
            //
                }
                
                // call the function
                func gotoProdauctdetailpageVC( productNum : Int) {
                    
                    var nameVC = ""
                    if productData[productNum].category != nil {
                        
                    let toVC = self.storyboard?.instantiateViewController(withIdentifier: "profileuploadimageDetails") as! profileuploadimageDetails
                                   toVC.oneProduct = productData[productNum]
                        self.navigationController?.pushViewController(toVC, animated: true)
                        let catagoryNum = Int(productData[productNum].category)
            //            switch  catagoryNum {
            //            case 0 :
            //                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "profileuploadimageDetails") as! profileuploadimageDetails
            //                toVC.oneProduct = productData[productNum]
            //                self.navigationController?.pushViewController(toVC, animated: true)
            //
            //
            //
            //            default:
            //                nameVC = ""
            //            }
                        
                        if nameVC.isEmpty {
                            return
                        }
//        else {
//
//            showToast("cat: \(curCatagory), select: \(indexPath.row)", duration: 1, position: .top)
//            self.gotoProdauctdetailpageVC(catagoryNum: curCatagory, productID: indexPath.row)
//        }
                    }
    }
    
}

extension BusinessInfoVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageProductCell", for: indexPath) as! MainpageProductCell
        cell.entity = productData[indexPath.row]
        
        return cell
    }
    
}

extension BusinessInfoVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var w : CGFloat = 0
        var h : CGFloat = 0

        w = (collectionView.frame.size.width - 10) / 2
        h = 220
        
        return CGSize(width: w, height: h)
    }
}
