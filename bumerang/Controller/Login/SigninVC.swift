//
//  SigninVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/5.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import GDCheckbox
import SwiftyUserDefaults
import SwiftyJSON
import FirebaseAuth
import FacebookCore
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Foundation

var signinVC : SigninVC!

class SigninVC: BaseViewController{

    var recoveryEmailVC : RecoveryEmailVC!
    var setNewPwdVC : SetNewPwdVC!
    var loginCount = 0
    
    
    
    @IBOutlet weak var ui_blackView: UIView!
    @IBOutlet weak var ui_emailTxt: CustomTextField!
    @IBOutlet weak var ui_pwdTxt: CustomTextField!
    @IBOutlet weak var ui_robotCheck: GDCheckbox!
    @IBOutlet weak var io_checkBox: UIButton!
    @IBOutlet weak var select_lbl: UILabel!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var standardBtn: dropShadowDarkButton!
    @IBOutlet weak var bussinessBtn: UIButton!
    //  @IBOutlet weak var cons_topView_top: NSLayoutConstraint!
    
    @IBOutlet weak var fbv1: UIView!
    
    
    @IBOutlet weak var googlev1: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          GIDSignIn.sharedInstance().clientID = "480946499113-6deojl08i8420vph3crmcsba8t2rv7rc.apps.googleusercontent.com"
          GIDSignIn.sharedInstance().delegate = self
        
        fbv1.clipsToBounds = true
        googlev1.clipsToBounds = true
        
        fbv1.cornerRadius = fbv1.frame.height/2
        
        googlev1.cornerRadius = googlev1.frame.height/2
        
                
        //MARK:- read from shared prefereces
        let preferences = UserDefaults.standard

        let Key = "key"

        if preferences.object(forKey: Key) == nil {
            
        } else {
            io_checkBox.isSelected = true
            let value = preferences.string(forKey: Key)
            self.ui_emailTxt.text = value?.components(separatedBy: "_")[0]
            self.ui_pwdTxt.text = value?.components(separatedBy: "_")[1]
        }
//
        
            
        
        
//        ui_emailTxt.text = ShareData.user_info.email
//        ui_pwdTxt.text = ShareData.user_info.pwd
                
      //  cons_topView_top.constant = UIScreen.main.bounds.height / 15
        
        signinVC = self
        
        ui_blackView.isHidden = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        recoveryEmailVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecoveryEmailVC") as! RecoveryEmailVC)
        recoveryEmailVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        
        setNewPwdVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetNewPwdVC") as! SetNewPwdVC)
        setNewPwdVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = popUpView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popUpView.addSubview(blurEffectView)
        popUpView.bringSubviewToFront(standardBtn)
        popUpView.bringSubviewToFront(bussinessBtn)
        popUpView.bringSubviewToFront(self.select_lbl)
        popUpView.isHidden = true
        
    }
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        
//        let toSignUP = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
//        self.modalPresentationStyle = .fullScreen
//        self.present(toSignUP, animated: true, completion: nil)
        popUpView.isHidden = false
        
        
    }
    
    @IBAction func onStandardBtn(_ sender: UIButton) {
        
//        self.gotoNavigationScreen("SignupVC", direction: .fromRight)
////        self.dissmisAndGot    oVC("SignupSetNav")
////        self.gotoNewVC("SingupSetVC")
//        sender.pulsate()
//
      
    let toSignUP = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
    self.modalPresentationStyle = .fullScreen
    self.present(toSignUP, animated: true, completion: nil)
    }
    
    @IBAction func onBussinessBtn(_ sender: UIButton) {
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SignupVC") as! SignupVC
        selectedUserType = 1
        toVC.modalPresentationStyle = .fullScreen
       // self.navigationController?.pushViewController(toVC, animated: true)
        self.present(toVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onDismissBtn(_ sender: Any) {
        popUpView.isHidden = true
    }
    @IBAction func onClickSignin(_ sender: UIButton) {
        sender.pulsate()
                
        let emailTxt = ui_emailTxt.text!
        let pwdTxt = ui_pwdTxt.text!
        
        if emailTxt.isEmpty {
            showToast(R_EN.string.INPUT_EMAIL, duration: 2, position: .center)
            return
        }
        
        if !isValidEmail(testStr: emailTxt) {
            showToast(R_EN.string.INVALID_EMAIL, duration: 2, position: .center)
            return
        }
            
        if pwdTxt.isEmpty {
            showToast(R_EN.string.INPUT_CONFIRM_PWD, duration: 2, position: .center)
            return
        } else {
            Auth.auth().signIn(withEmail: emailTxt, password: pwdTxt) { [weak self] authResult, error in
                if error == nil {
                  
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
                                
//                        Defaults[.userId] = uid
                        self?.gotoTabVC("MainpageAfterNav")
                        staticValue.registerStatus = "1"
//                        self!.setRememberState()
                              
                              }) { (error) in
                                print(error.localizedDescription)
                            }
                            
//                    ShareData.dbUserRef.child(userid!).observeSingleEvent(of: .value, with: { (snapshot) in
//                      // Get user value
//                      let value = snapshot.value as? NSDictionary
////                      let userid = value?["ShareData.Tuserid"] as? String ?? ""
//                        let fname = value?["ShareData.Tuserfirstname"] as? String ?? ""
//                        let lname = value?["ShareData.Tuserlastname"] as? String ?? ""
//                        let email = value?["ShareData.Tuseremail"] as? String ?? ""
//                        let pwd = value?["ShareData.Tuserpassword"] as? String ?? ""
//                        let gmail = value?["ShareData.TgoogleEmail"] as? String ?? ""
//                        let fmail = value?["ShareData.TfacebookEmail"] as? String ?? ""
//                        let usertype = value?["ShareData.TuserType"] as? String ?? ""
//                        let membership = value?["ShareData.TuserMemberShip"] as? String ?? ""
//                        let phone = value?["ShareData.Tuserphone"] as? String ?? ""
//                        let avatarurl = value?["ShareData.Tuserphotoid"] as? String ?? ""
//                        let score = value?["ShareData.TuserScore"] as? String ?? ""
//                        let address = value?["ShareData.TuserAddress"] as? String ?? ""
//                        let city = value?["ShareData.TuserCity"] as? String ?? ""
//                        let lat = value?["ShareData.Tuserlatitude"] as? String ?? ""
//                        let lng = value?["ShareData.Tuserlongitude"] as? String ?? ""
//                        let emailveri = value?["ShareData.TuserEmailVerified"] as? String ?? ""
//                        let phoneveri = value?["ShareData.TuserPhoneVerified"] as? String ?? ""
//                        let idveri = value?["ShareData.TuserIdVerfied"] as? String ?? ""
//                        let updatedat = value?["ShareData.TuserUpdatedAt"] as? String ?? ""
//                        let createdat = value?["ShareData.TuserCreatedAt"] as? String ?? ""
//
//                        let storingDict:[String:String] = [ShareData.Tuserid: userid!, ShareData.Tuserfirstname: fname, ShareData.Tuserlastname: lname, ShareData.Tuseremail: email, ShareData.Tuserpassword: pwd, ShareData.TgoogleEmail: gmail, ShareData.TfacebookEmail: fmail, ShareData.TuserType: usertype, ShareData.TuserMemberShip: membership, ShareData.Tuserphone: phone, ShareData.Tuserphotoid: avatarurl, ShareData.TuserScore: score, ShareData.TuserAddress: address, ShareData.TuserCity: city, ShareData.Tuserlatitude: lat, ShareData.Tuserlongitude: lng, ShareData.TuserEmailVerified: emailveri, ShareData.TuserPhoneVerified: phoneveri, ShareData.TuserIdVerfied: idveri, ShareData.TuserUpdatedAt: updatedat, ShareData.TuserCreatedAt: createdat]
//                        //
//                        //
//                        //
//                       ShareData.user_info = Users.init(dict: storingDict)
//
//
//
//
//
//                      // ...
//                      }) { (error) in
//                        print(error.localizedDescription)
//                    }

                    
//                    print("\(staticValue.registerStatus)")
                }else {
                    self?.showToast("Bu bilgi ile oturum açamazsınız!", duration: 2, position: .center)
                }
              
            }
            
            
//            if Defaults[.rememberState] == true {
////                self.gotoMainAfterVC()
//                self.gotoTabVC("MainpageAfterNav")
//            } else {
//
//                let authType = Constants.mailType[0]
//                gotoSigninAPI(email: emailTxt, pwd: pwdTxt, auth_type : authType)
//            }
        }

    }
    
    func showSignupGroups(){
        UIView.animate(withDuration: 0.35, animations: {
            self.popUpView.isHidden = !self.popUpView.isHidden
            
            if self.popUpView.isHidden {
                
                //self.ui_butSign.setTitle("SIGN UP", for: .normal)
                self.standardBtn.frame = CGRect(x: self.view.frame.width/2 - 60, y: self.view.height , width: 120, height: 35)
                self.bussinessBtn.frame = CGRect(x: self.view.frame.width/2 - 60, y: self.view.height , width: 120, height: 35)
                
            } else {
                //self.ui_butSign.setTitle("X", for: .normal)
              
                
                self.standardBtn.frame = CGRect(x: self.view.frame.width/2 - 150, y: self.view.height - 200 , width: 120, height: 35)
                                 
                self.bussinessBtn.frame = CGRect(x: self.view.frame.width/2 + 30, y: self.view.height - 200 , width: 120, height: 35)
            
           }
        }, completion: { (true) in
            self.standardBtn.pulsate()
            self.bussinessBtn.pulsate()
        } )
    }
    
    @IBAction func onTapedGoogleSignIn(_ sender: UIButton) {
        
          sender.pulsate()
     
        GIDSignIn.sharedInstance()?.presentingViewController = self
       GIDSignIn.sharedInstance()?.signIn()
    
    }
    
    
//    func gotoSigninAPI(email : String, pwd : String, auth_type : String) {
//
//        showHUD()
////        self.showALLoadingViewWithTitle(title: "Waiting", type: .messageWithIndicator )
//
//        // call api
//        UserApiManager.login(email: email, pwd: pwd, auth_type : auth_type){ (isSuccess, data) in
//
//            self.hideHUD()
////            self.hideALLoadingView()
//            if isSuccess {
//
//                g_user = UserModel(userinfo: JSON(data!))
//                g_user.pwd = pwd
//
//                Defaults[.firstname] = g_user.first_name
//                Defaults[.lastname] = g_user.last_name
//                Defaults[.userId] = g_user.userId
//                Defaults[.email] = g_user.email
//                Defaults[.pwd] = pwd
//                Defaults[.registerState] = true
//                Defaults[.userType] = g_user.user_type
//
//                self.setRememberState()
////                self.gotoMainAfterVC()
//                self.gotoTabVC("MainpageAfterNav")
//
//            } else {
//
//                if data == nil {
//                    if self.loginCount == 2 {
//                        self.loginCount += 1
//                        self.gotoSigninAPI(email: email, pwd: pwd, auth_type : auth_type)
//                    } else {
//                        self.showToast(R_EN.string.CONNECT_FAIL)
//                    }
//                } else {
//                    self.showToast(JSON(data!).stringValue)
//                }
//            }
//        }
//    }
    
    @IBAction func onCheckBoxPress(_ sender: GDCheckbox) {
        
        ui_robotCheck.containerColor = UIColor(named: "black")!
    }
    
    // chage CheckSbox tate
    @IBAction func onClickRobot(_ sender: Any) {
        
        ui_robotCheck.isOn = !ui_robotCheck.isOn
        ui_robotCheck.containerColor = UIColor(named: "black")!
        //setRememberState()
    }
    
    //MARK:- chage CheckSbox tate
    @IBAction func onClickCheckBox(_ sender: Any) {
        let preferences = UserDefaults.standard

                let Key = "key"
        if io_checkBox.isSelected == false {
            io_checkBox.isSelected = true
            let value = self.ui_emailTxt.text! + "_" + self.ui_pwdTxt.text!
            preferences.set(value, forKey: Key)
            
        } else {
            io_checkBox.isSelected = false
            preferences.removeAll()
        }
    }
    
    @IBAction func onClickForgot(_ sender: Any) {
        ui_blackView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            
            let sub1VC = self.recoveryEmailVC
            sub1VC!.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view.addSubview(sub1VC!.view)
            
            self.addChild(sub1VC!)
            
        })
    }
    
    @IBAction func onClickFBSignup(_ sender: UIButton) {

             sender.pulsate()
            let loginManager = LoginManager()
            
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self](result, error) in
                
                if error != nil {
                    print("Login failed")
                } else {
                    if result!.isCancelled { print("login Cancelled") }
                    else { self!.getFaceBookUserData()
                        
                    }
                }
            }
//        }
    }
    
    func getFaceBookUserData() {
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name"])) { (httpResponse, result, error) in

//            print("graph AP I result: ", result)
            let jsonResult = JSON(result!)
            let fname = jsonResult["first_name"].stringValue
            let lname = jsonResult["last_name"].stringValue
            let email = jsonResult["email"].stringValue
            
            let id = jsonResult["id"].intValue
            let profile_photo = "http://graph.facebook.com/\(id)/picture?type=large"

            
            print(id, " : ", email)
            print(fname, " : ", lname)
            print(profile_photo)
            
//            self.gotoSigninAPI(email : email, pwd : "", auth_type : Constants.mailType[1])
            
        }

        connection.start()
    }
    
    
    func gotoSetPwdVC(_ userId: String) {
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            let subVC = self.setNewPwdVC
            subVC!.userId = userId
            subVC!.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view.addSubview(subVC!.view)
            
            self.addChild(subVC!)
        })
        
    }
    
    func hideSetNewPwdVC() {
        UIView.animate(withDuration: 0.2, animations: {
            self.setNewPwdVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.setNewPwdVC.view.willRemoveSubview(self.setNewPwdVC.view)
        })
        ui_blackView.isHidden = true
        
    }
    
    func hideRecoveryEmailVC(_ blackViewState: Bool){
        
        self.recoveryEmailVC.view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.recoveryEmailVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.recoveryEmailVC.view.willRemoveSubview(self.recoveryEmailVC.view)
        })
        
        ui_blackView.isHidden = blackViewState
        
    }
    
}


extension SigninVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        
        if let error = error {
            print(error.localizedDescription)
       
            print("error wala")
            
            
            
            return
            
    }
        print("hiiiiiiiiiiiiiii")
//         let email = user.profile.email
        
        
        
     
//        gotoSigninAPI(email : email!, pwd : "", auth_type : Constants.mailType[2])
        
   }
        

}



extension UITextField {
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcon(_ icon: UIImage) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
}
