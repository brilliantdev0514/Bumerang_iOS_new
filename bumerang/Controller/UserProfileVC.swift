//
//  UserProfileVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/13.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController
import DKCamera
import SwiftyJSON
import SwiftyUserDefaults
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase

class UserProfileVC: BaseViewController {

    @IBOutlet weak var ui_imgAvatar: UIImageView!
    @IBOutlet weak var ui_txtFname: CustomTextField!
    @IBOutlet weak var ui_txtLname: CustomTextField!
    @IBOutlet weak var ui_lblNameVerify: UILabel!
    @IBOutlet weak var ui_txtMail: CustomTextField!
    
    @IBOutlet weak var ui_lbleMailVerify: UILabel!
    @IBOutlet weak var ui_txtPhone: CustomTextField!
    @IBOutlet weak var ui_lblPhoneVerify: UILabel!
    @IBOutlet weak var ui_txtAddr: CustomTextField!
    @IBOutlet weak var ui_lblAddrSave: UILabel!
    @IBOutlet weak var ui_txtCity: CustomTextField!
    @IBOutlet weak var ui_lblCitysave: UILabel!
    
    @IBOutlet weak var ui_imgFacebook: UIImageView!
    @IBOutlet weak var ui_imgGoogle: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser!.uid
                ShareData.dbUserRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                  // Get user value
                    if !snapshot.exists() {
                        // handle data not found
                        return
                    }
                    let userData = snapshot.value as! [String: String]
        //          Users user = Users.init(dict: value)
                  ShareData.user_info = Users.init(dict: userData)
                    
                  // ...
                  }) { (error) in
                    print(error.localizedDescription)
                }
        
//
//
//
//        // Do any additional setup after loading the view.
//        ui_txtFname.text = Defaults[.firstname]
//        ui_txtLname.text = Defaults[.lastname]
//        ui_txtMail.text = Defaults[.email]
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        ui_txtFname.text = ShareData.user_info.first_name + " " + ShareData.user_info.last_name
       // ui_txtLname.text = ShareData.user_info.last_name
        ui_txtMail.text = ShareData.user_info.email
        if ShareData.user_info.avatarUrl != "" {
            self.ui_imgAvatar.sd_setImage(with: URL(string: ShareData.user_info.avatarUrl), placeholderImage: UIImage.init(named: "ic_avatar"))
        }
        
        ui_txtPhone.text = ShareData.user_info.phone_num
        ui_txtCity.text = ShareData.user_info.pwd
        
        //setupMenuButton()
    }

    @IBAction func onTapedAvatarAdd(_ sender: Any) {
        let galleryAction = UIAlertAction(title: "from gallery", style: .destructive) { (action) in
            self.openGallary()
        }
        let cameraAction = UIAlertAction(title: "from camera", style: .destructive) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title:R_EN.string.CANCEL, style: .cancel, handler : nil)
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: R_EN.string.APP_TITLE, message: R_EN.string.CORNFRIM_IMAGE_SETMODE, preferredStyle: .actionSheet)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTapedMembership(_ sender: Any) {
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SelectMembershipVC") as! SelectMembershipVC
        //toVC.selectCategory = sender.tag
        toVC.modalPresentationStyle = .fullScreen
        
        self.present(toVC, animated: true, completion: nil)
    }
    
    @IBAction func onTapedSave(_ sender: Any) {
        
        var FNAME: String!
        var LNAME: String!
        var ADDR: String?
        var MAIL: String!
        var PHONE: String!
        var PASS: String!
        FNAME = ui_txtFname.text
       // LNAME = ui_txtLname.text
        ADDR = ui_txtAddr.text ?? ""
        MAIL = ui_txtMail.text
        PHONE = ui_txtPhone.text
        PASS = ui_txtCity.text
        if FNAME == "" {
            showToast("İsminizi girin", duration: 1, position: .center)
            return
        }
        if LNAME == "" {
            showToast("Soyadınızı girin", duration: 1, position: .center)
            return
        }
       /* if ADDR == "" {
            showToast("Adresinizi giriniz", duration: 1, position: .center)
            return
        }*/
        if MAIL == "" {
            showToast("Mail adresinizi girin", duration: 1, position: .center)
            return
        }
        if PHONE == "" {
            showToast("Telefon numaranızı girin", duration: 1, position: .center)
            return
        }
        if PASS == "" {
            showToast("Şifrenizi girin", duration: 1, position: .center)
            return
        }
        if ui_imgAvatar.image == nil {
            showToast("Profil fotoğrafınızı seçin", duration: 1, position: .center)
            return
        }
    
        
        uploadMedia() { url in
            var avatarURL: String!
              avatarURL = url
            
            self.updataPofile(photo: avatarURL, fname: FNAME, lname: LNAME ?? "", location: ADDR ?? "nil", email: MAIL, phone: PHONE, password: PASS)
                self.showToast("Tamamlandı", duration: 1, position: .center)
                
                
            }
        
        
    }
    
    func updataPofile(photo : String, fname: String, lname: String, location: String, email: String, phone: String, password: String){
        
        let userid = Auth.auth().currentUser?.uid
        let storingDict:[String:String] = [ShareData.Tuserid: userid!, ShareData.Tuserfirstname: fname, ShareData.Tuserlastname: lname, ShareData.Tuseremail: email, ShareData.Tuserpassword: password, ShareData.TgoogleEmail: "", ShareData.TfacebookEmail: "", ShareData.TuserType: "", ShareData.TuserMemberShip: "", ShareData.Tuserphone: phone, ShareData.Tuserphotoid: photo, ShareData.TuserScore: "", ShareData.TuserAddress: location, ShareData.TuserCity: "", ShareData.Tuserlatitude: "", ShareData.Tuserlongitude: "", ShareData.TuserEmailVerified: "", ShareData.TuserPhoneVerified: "", ShareData.TuserIdVerfied: "", ShareData.TuserUpdatedAt: "", ShareData.TuserCreatedAt: ""]
        
        ShareData.dbUserRef.child(userid!).setValue(storingDict)
        ShareData.user_info = Users.init(dict: storingDict)
        
    }
    
    func setupMenuButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"ic_logout"), for: .normal)
        menuBtn.addTarget(self, action: #selector(rightbuttonPressed), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
        
    }
    @IBAction func onTapedLogout(_ sender: Any) {
        rightbuttonPressed()
    }
    
    @objc func rightbuttonPressed() {
        
        let str = "Çıkmak istiyor musunuz?"
        
        let alert = UIAlertController(title: str, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R_EN.string.CANCEL, style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: R_EN.string.OK, style: .default, handler : {(action) -> Void in
            
            staticValue.registerStatus = ""
            self.dissmisAndGotoVC("SigninVC")
            
        }))
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
        
    }

    @IBAction func onTapedLike(_ sender: Any) {
        self.showToast("You select like")
    }
    
    @IBAction func onTapedBack(_ sender: Any) {
        
        if (ShareData.user_info.membership == "1") {
            let toVC = storyboard?.instantiateViewController(withIdentifier: "BusinessInfoVC") as! BusinessInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        } else {
            let toVC = storyboard?.instantiateViewController(withIdentifier: "StandardInfoVC") as! StandardInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        }
    }
    //MARK:- image choose from camera
       func openCamera(){
           if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
               //If you dont want to edit the photo then you can set allowsEditing to false
               imagePicker.allowsEditing = true
               imagePicker.delegate = self
               self.present(imagePicker, animated: true, completion: nil)
           }
           else{
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: R_EN.string.OK, style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
       
       
        //MARK:- image choose from gallary
        func openGallary(){
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    //MARK:- image upload
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("images").child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //ui_uploadImg.image error
        guard let imageData = self.ui_imgAvatar.image!.jpegData(compressionQuality: 0.75) else { return }
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
          
          if error == nil, metaData != nil {

            storageRef.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {

                    completion(urlText)

                }
            })
            
          } else {
              // failed
              completion(nil)
          }
         
        }
    }
    
    
}

//MARK:-UIImagePickerControllerDelegate
extension UserProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.ui_imgAvatar.image = selectedImage
            
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.ui_txtAddr.text = addressString
                    }
                    
                    
              }
        })

    }
}

// MARK: - CLLocationManagerDelegate
//1
extension UserProfileVC: CLLocationManagerDelegate {
  // 2
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.startUpdatingLocation()

  }
  
  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      
    let lat_str = String.init(format: "%lf", abs(location.coordinate.latitude))
    let lng_str = String.init(format: "%lf", abs(location.coordinate.longitude))
    self.getAddressFromLatLon(pdblLatitude: lat_str, withLongitude: lng_str)
    
    // 8
    locationManager.stopUpdatingLocation()
  }
}
