//
//  profileuploadimageDetails.swift
//  bumerang
//
//  Created by mac on 27/02/20.
//  Copyright © 2020 RMS. All rights reserved.
//

import UIKit
import UIKit
import MapKit
import SwiftyUserDefaults
import Firebase
import FirebaseAuth
import FirebaseDatabase

class profileuploadimageDetails: BaseViewController {

    var productUser : Users? = nil
    var oneProduct : ProductModels? = nil
    @IBOutlet weak var ui_editBtn: UIButton!
    @IBOutlet weak var ui_lblRentState: UILabel!
    @IBOutlet weak var ui_imgRentState: UIImageView!
    @IBOutlet weak var ui_imgProduct: UIImageView!
    @IBOutlet weak var ui_txtTIlte: UITextField!
    @IBOutlet weak var ui_txtAddr: UITextField!
    @IBOutlet weak var ui_txtFuel: UITextField!
    @IBOutlet weak var ui_txtGear: UITextField!
    @IBOutlet weak var ui_txtDoor: UITextField!
    @IBOutlet weak var ui_txtCartype: UITextField!
    @IBOutlet weak var ui_txtPrice: UILabel!
    @IBOutlet weak var ui_txtDeposit: UITextField!
    @IBOutlet weak var ui_txvDescription: UITextView!
    @IBOutlet weak var ui_mapView: MKMapView!
    
    @IBOutlet weak var ui_viewRent: UIView!
    @IBOutlet weak var ui_avatarView: UIView!
    @IBOutlet weak var ui_imgAvatar: UIImageView!
    @IBOutlet weak var ui_lblBUsername: UILabel!
 
    
    @IBOutlet weak var ui_imgEmail: UIImageView!
    @IBOutlet weak var ui_imgPhone: UIImageView!
    @IBOutlet weak var ui_imgGmail: UIImageView!
    @IBOutlet weak var ui_imgFace: UIImageView!
    
    @IBOutlet weak var ui_messageButton: UIButton!
    @IBOutlet weak var ui_editButton: UIButton!
    @IBOutlet weak var ui_delButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let oneProduct = oneProduct else {
            return
        }
        
        ui_editBtn.isHidden = true;
        self.loadDitailData(oneProduct)
        ui_avatarView.cornerRadius = ui_avatarView.bounds.width/2
        ui_messageButton.cornerRadius = ui_messageButton.bounds.height/2
        
        if Auth.auth().currentUser!.uid == oneProduct.owner_id {
            ui_editButton.isHidden = false
            ui_delButton.isHidden = false
            ui_messageButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
//        ui_viewRent.cornerRadius = ui_viewRent.bounds.height/2
        
    }

    func loadDitailData(_ oneData : ProductModels) {
        
        if oneData.image_url.starts(with: "http") {
            ui_imgProduct.sd_setImage(with: URL(string: oneData.image_url))
        }
        else {
            ui_imgProduct.image = UIImage(named: oneData.placeHolerImage)
        }
//        ui_imgRentState.isHidden = !oneData.rental_status
        ui_imgRentState.isHidden =  true
        ui_txtTIlte.text = oneData.title
        ui_txtAddr.text = oneData.address
        ui_txtFuel.text = "Yakıt : \(String(oneData.fuel_type))"
        ui_txtGear.text = "Vites : \(String(oneData.gear_type))"
        ui_txtDoor.text = "Kapı Sayısı : \(String(oneData.door_number))"
        ui_txtCartype.text = "Araç Tipi : \(String(oneData.car_type))"
        //ui_txtPrice.text = "$" + oneData.price+"/"+oneData.date_unit
        ui_txtPrice.text = oneData.price + "₺\n/günlük"
        ui_txtDeposit.text = "Depozito : \(String(oneData.deposit))"
        
        ui_txvDescription.text = oneData.description
        
        var coor = CLLocationCoordinate2D()
        coor.latitude  = Double(oneData.lat!)!
        coor.longitude  = Double(oneData.lng!)!

        if CLLocationCoordinate2DIsValid(coor) {
            ui_mapView.centerCoordinate = coor
        }

        ShareData.dbUserRef.child(oneData.owner_id).observeSingleEvent(of: .value, with: { (snapshot) in
                  // Get user value
                    if !snapshot.exists() {
                        // handle data not found
                        return
                    }
                    let userData = snapshot.value as! [String: String]
        //          Users user = Users.init(dict: value)
            self.productUser = Users.init(dict: userData)
            self.ui_lblBUsername.text = self.productUser!.first_name + " " + self.productUser!.last_name
                  }) { (error) in
                    print(error.localizedDescription)
                }
       // ui_lblBUsername.text = String(oneData.userinfo_fname) + " " + String(oneData.userinfo_lname)
      
        
        
        //  ui_lblRatingval.text = String(oneData.userinfo_rating)
        
//        ui_imgEmail.image = UIImage(named: "ic_mail_" + (oneData.userinfo_mailState ? "blue" : "grey"))
//
//        ui_imgPhone.image = UIImage(named: "ic_phone_" + (oneData.userinfo_mailState ? "blue" : "grey"))
//
//        ui_imgGmail.image = UIImage(named: "ic_google_" + (oneData.userinfo_mailState ? "verified" : "unverified"))
//
//        ui_imgFace.image = UIImage(named: "ic_facebook_" + (oneData.userinfo_mailState ? "verified" : "unverified"))
        
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.hideHUD()
//        })
    }
    
    
    
    
      @IBAction func gobuisnesspro(_ sender: Any) {
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
    
    @IBAction func shareAction(_ sender: Any) {
                
        
        let url  = NSURL(string: "https://apps.apple.com/us/app/joyofy/id1446173204?ls=1")

        if UIApplication.shared.canOpenURL(url! as URL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url! as URL)
            }
        }
    }
    
      
    @IBAction func editDescription(_ sender: Any)
    {
        if Auth.auth().currentUser!.uid == oneProduct?.owner_id
        {
            ui_editBtn.setTitle("Save changed data!", for: .normal)
            ui_editBtn.setTitleColor(UIColor.blue, for: .normal)
            ui_txvDescription.isEditable = true
            let data: [String: String] = [ProductData.description: ui_txvDescription.text]
            ProductData.dbProRef.child(oneProduct!.product_id).updateChildValues(data)
        }else
        {
            self.showToast("You can't edit this product description!", duration: 2, position: .center)
        }
    }
    
    
    
    
    
    
    
    @IBAction func onTapedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        
        let alert = UIAlertController(title: R_EN.string.TEXT_1, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Evet", style: .default, handler : {(action) -> Void in
                                
                    ProductData.dbProRef.child(self.oneProduct!.product_id).removeValue()
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                
                DispatchQueue.main.async(execute:  {
                    self.present(alert, animated: true, completion: nil)
                })
       }
    
    @IBAction func onClickUpdate(_ sender: Any) {
     
        setTransitionType(.fromLeft)
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "AddCarVC") as! AddCarVC
        toVC.oneProduct = oneProduct
        
        toVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        
        if ShareData.user_info.userId == oneProduct?.owner_id {
            
            showToast(R_EN.string.CHAT_REQUEST_FAIL_USER, duration: 2, position: .center)
            return
        } else if staticValue.registerStatus == "0" {
            
            showToast(R_EN.string.CHAT_REQUEST_FAIL_LOGIN, duration: 2, position: .center)
            return
        }
        
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        toVC.receiveUserId = oneProduct!.owner_id
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func onClickRent(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.25, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        },
        completion: nil)
        
        UIButton.animate(withDuration: 0.25, animations: {
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
        completion: { finish in
            UIButton.animate(withDuration: 2, animations: {
                sender.transform = CGAffineTransform.identity
//                self.gotoRent()
            })
        })
    }
   
    func gotoRent(){
        if ShareData.user_info.userId == oneProduct?.owner_id {
            showToast(R_EN.string.RENT_REQUEST_FAIL_USER, duration: 2, position: .center)
            return
        } else if staticValue.registerStatus == "0" {
            
            showToast(R_EN.string.RENT_REQUEST_FAIL_LOGIN, duration: 2, position: .center)
            return
        }
        
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "RentPorductVC") as! RentPorductVC
//        toVC.oneProduct = self.oneProduct
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}





extension profileuploadimageDetails: UICollectionViewDataSource,UICollectionViewDelegate{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print(oneProduct!.image_urls,oneProduct!.image_urls.count)
             return oneProduct!.image_urls.count
    //        if oneProduct!.image_url.starts(with: "http") {
    //
    //
    //                   let str = oneProduct!.image_url.components(separatedBy: ",")
    //            print(str,oneProduct!.image_urls,oneProduct!.image_urls.count)
    //
    //            return oneProduct!.image_urls.count
    //
    //
    //
    //         }else{
    //            return 1
    //        }
           
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as! homecollectionviewcell
           
            if ((oneProduct?.image_urls.count)! > 0) {
            
            cell.image.sd_setImage(with: URL.init(string: oneProduct!.image_urls![indexPath.row] as! String), completed: nil)
                
                
    //            let str = oneProduct!.image_url.components(separatedBy: ",")
    //
    //            if indexPath.row == 0{
    //
    //                cell.image.sd_setImage(with: URL(string: str[0]))
    //
    //
    //
    //            }else{
    //
    //               // let index = str[0].index(str[0].startIndex, offsetBy: 26)
    //
    //               // let baseurl = String(str[0].prefix(upTo: index))
    //
    //             //   print(baseurl)
    //
    //                cell.image.sd_setImage(with: URL.init(string: oneProduct!.image_urls![indexPath.row] as! String), completed: nil)
    //
    //
    //
    //            }get
    //
    //
    //
                     
                 }
                 else {
                     
                  cell.image.image = UIImage(named: oneProduct!.placeHolerImage)
                     
                 }
            
          
               
            
            
            
            
            return cell
        }
        
    
    
    
    
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.performBatchUpdates(nil, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            let height = (view.frame.width) * 3/4
            return CGSize(width: view.frame.width, height: height + 50 + 150)
        default:
            let height = (view.frame.width) * 9 / 16
            return CGSize(width: view.frame.width, height: height + 50 + 50)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

