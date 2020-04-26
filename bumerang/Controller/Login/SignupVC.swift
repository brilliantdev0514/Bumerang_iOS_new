
import UIKit
import SwiftyJSON
import SwiftyUserDefaults

import FacebookCore
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class SignupVC: BaseViewController {

    @IBOutlet weak var lnameTxt : CustomTextField!
    @IBOutlet weak var fnameTxt : CustomTextField!
    @IBOutlet weak var emailTxt : CustomTextField!
    @IBOutlet weak var pwdTxt : CustomTextField!
    @IBOutlet weak var confPwdTxt : CustomTextField!
    @IBOutlet weak var ui_lblUserType: UILabel!
    @IBOutlet weak var bun_terms: UIButton!
    @IBOutlet weak var btn_privacy: UIButton!
    

//    var userArray: [User] = []
//    var ref: DatabaseReference!
    let userTypeColor = ["primary", "redColor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        let userType = Constants.userType[selectedUserType]
//        ref = Database.database().reference()
//        ui_lblUserType.text = "You are \(userType) user in Bumerang"
//        ui_lblUserType.textColor = UIColor(named: userTypeColor[selectedUserType])
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        
        
        sender.pulsate()
        
        let lname = lnameTxt.text!.trimmed
        let fname = fnameTxt.text!.trimmed
        let email = emailTxt.text!.trimmed
        let pwd = pwdTxt.text!.trimmed
        let confPwd = confPwdTxt.text!.trimmed
        
        if lname.isEmpty {
            showToast(R_EN.string.INPUT_LNAME, duration: 2, position: .center)
            return
        }
        
        if fname.isEmpty {
            showToast(R_EN.string.INPUT_FNAME, duration: 2, position: .center)
            return
        }
        
        if email.isEmpty {
            showToast(R_EN.string.INPUT_EMAIL, duration: 2, position: .center)
            return
        } else if !isValidEmail(testStr: email) {
            showToast(R_EN.string.INVALID_EMAIL, duration: 2, position: .center)
            return
        }
        
        if pwd.isEmpty {
            showToast(R_EN.string.INPUT_PWD, duration: 2, position: .center)
            return
        }
        
        if confPwd.isEmpty {
            showToast(R_EN.string.INPUT_CONFIRM_PWD, duration: 2, position: .center)
            return
        }
        
        if pwd != confPwd {
            showToast(R_EN.string.INVAILD_PWD, duration: 2, position: .center)
            return
        }
//        let userTypeApi = Constants.userTypeAPI[selectedUserType]
//        let authType = Constants.mailType[0]
//        gotoSignupAPI(fname: fname, lname: lname, email: email, pwd: pwd, user_type: userTypeApi, auth_type: authType)
        
        if selectedUserType == 1 {
            
            let storingDict:[String:String] = [ShareData.Tuserid: "", ShareData.Tuserfirstname: fname, ShareData.Tuserlastname: lname, ShareData.Tuseremail: email, ShareData.Tuserpassword: pwd, ShareData.TgoogleEmail: "", ShareData.TfacebookEmail: "", ShareData.TuserType: Constants.userType[selectedUserType], ShareData.TuserMemberShip: staticValue.memberShipVar, ShareData.Tuserphone: "", ShareData.Tuserphotoid: "", ShareData.TuserScore: "", ShareData.TuserAddress: "", ShareData.TuserCity: "", ShareData.Tuserlatitude: "", ShareData.Tuserlongitude: "", ShareData.TuserEmailVerified: "", ShareData.TuserPhoneVerified: "", ShareData.TuserIdVerfied: "", ShareData.TuserUpdatedAt: "", ShareData.TuserCreatedAt: ""]
            ShareData.user_info = Users.init(dict: storingDict)
            
            let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SelCategoryBusinessVC") as! SelCategoryBusinessVC
             toVC.modalPresentationStyle = .fullScreen
            // self.navigationController?.pushViewController(toVC, animated: true)
             self.present(toVC, animated: true, completion: nil)
            
        } else {
            //MARK:- Firebase auth create and date write by model
            Auth.auth().createUser(withEmail: email, password: pwd) { user, error in
              if error == nil {

                Auth.auth().signIn(withEmail: email, password: pwd)
                let userid = Auth.auth().currentUser?.uid
                let storingDict:[String:String] = [ShareData.Tuserid: userid!, ShareData.Tuserfirstname: fname, ShareData.Tuserlastname: lname, ShareData.Tuseremail: email, ShareData.Tuserpassword: pwd, ShareData.TgoogleEmail: "", ShareData.TfacebookEmail: "", ShareData.TuserType: Constants.userType[0], ShareData.TuserMemberShip: "", ShareData.Tuserphone: "", ShareData.Tuserphotoid: "", ShareData.TuserScore: "", ShareData.TuserAddress: "", ShareData.TuserCity: "", ShareData.Tuserlatitude: "", ShareData.Tuserlongitude: "", ShareData.TuserEmailVerified: "", ShareData.TuserPhoneVerified: "", ShareData.TuserIdVerfied: "", ShareData.TuserUpdatedAt: "", ShareData.TuserCreatedAt: ""]
                
                ShareData.dbUserRef.child(userid!).setValue(storingDict)
                ShareData.user_info = Users.init(dict: storingDict)
                
                
                self.showToast("Signup is success!", duration: 2, position: .center)
                
                staticValue.registerStatus = "1"
                let goto = self.storyboard?.instantiateViewController(withIdentifier: "BeforeSignupVC") as! BeforeSignupVC
                self.modalPresentationStyle = .fullScreen
                self.present(goto, animated: true, completion: nil)
                }else {
                
                  print("Authentication failed \(error?.localizedDescription ?? "error")")
                }
        }
        
        
            
//
//            // retrieve
//            ShareData.dbUserRef.child(ShareData.user_info.userId).observeSingleEvent(of: .Ev, with: <#T##(DataSnapshot) -> Void#>)
//            snapshot...
//            let value = snapshot.value as! Dictionary
//            Users user = Users.init(dict: value)
//            // name and email..upddate
//            ShareData.user_info = Users.init(dict: value)
//            ShareData.Tuserfirstname = "sdfsdf"
//
//            //// convert Users model -> Dinctionary to set fireDB
//            let storingDictionary = ShareData.getDictFromUsersModel(user: ShareData.user_info)
//            ...set
          
        }
        
    }
    
    
    @IBAction func onClickFBSignup(_ sender: UIButton) {
        
        sender.pulsate()
            

        
            let loginManager = LoginManager()
            
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self](result, error) in
                
                if error != nil {
                    print("Login failed")
                } else {
                    if result!.isCancelled { print("login canceled") }
                    else { self!.getFaceBookUserData() }
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
            
            self.gotoSignupAPI(fname: fname, lname: lname, email: email, pwd: "", user_type: Constants.userTypeAPI[selectedUserType], auth_type: Constants.mailType[1])
        }

        connection.start()
    }
    
    @IBAction func onTappedGoogleSignup(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onTapedTerms(_ sender: Any) {
        
       // self.gotoNavigationScreen("TermsVC")
        
        let toTermsVC = storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        self.modalPresentationStyle = .fullScreen
        self.present(toTermsVC, animated: true, completion: nil)
    }
    
    @IBAction func onTapedPrivacy(_ sender: Any) {
        
        self.gotoNavigationScreen("PrivencyVC")
        
        let toPrivencyVC = storyboard?.instantiateViewController(withIdentifier: "PrivencyVC") as! PrivencyVC
               self.modalPresentationStyle = .fullScreen
               self.present(toPrivencyVC, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pulseButtonPressed(_ sender: UIButton) {
        
        
    }
       
    @IBAction func flashButtonPressed(_ sender: UIButton) {
           sender.flash()
    }

    @IBAction func shakeButtonPressed(_ sender: UIButton) {
           sender.shake()
        
    }
    
 
    
    
    @IBAction func onClickSignin(_ sender: UIButton) {
        
        sender.pulsate()
        
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SigninVC") as! SigninVC
//        self.navigationController?.pushViewController(toVC, animated: true)
//
//        let toSignUP = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: true, completion: nil)
    }
    

    
    
//    func dissmisAndGotoVC (_ nameVC: String) {
//
//        self.dismiss()
//        self.gotoNewVC(nameVC)
//    }
//
//    //Goto new VC
//    func gotoNewVC (_ nameVC: String) {
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyBoard.instantiateViewController(withIdentifier: nameVC)
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: false, completion: nil)
//    }
//    //dissmis current VC
//    func dismiss() {
//        self.storyboard?.instantiateInitialViewController()?.dismiss(animated: true, completion: nil)
//    }
    
    func gotoSignupAPI(fname: String, lname: String, email: String, pwd: String, user_type: String, auth_type: String) {
        
        //self.showALLoadingViewWithTitle(title: "Waiting", type: .messageWithIndicator, mode: .windowed)
        
//        showHUDWithTitle(title: "Waiting")
//        
//        UserApiManager.signup(fname: fname, lname: lname, email: email, pwd: pwd, user_type: user_type, auth_type: auth_type) { (isSuccess, data) in
//            
////            self.hideALLoadingView()
//            self.hideHUD()
//            
//            if isSuccess {
//                
//                g_user = UserModel(userinfo: JSON(data!))
//                g_user.pwd = pwd
//                
//                Defaults[.firstname] = g_user.first_name
//                Defaults[.lastname] = g_user.last_name
////                Defaults[.userId] = g_user.userId
//                Defaults[.email] = g_user.email
//                Defaults[.pwd] = pwd
//                Defaults[.registerState] = "1"
//                Defaults[.userType] = g_user.user_type
//                
//                self.gotoTabVC("MainpageAfterNav")
//                
//            } else {
//
//                if data == nil {
//                    self.showToast(R_EN.string.CONNECT_FAIL)
//
//                } else {
//                    self.showToast(JSON(data!).stringValue)
//                }
//            }
//        }
    }
}

extension SignupVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
    //        guard  let auth = user.authentication else {
    //            return
    //        }
            
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            
        print(userId!, idToken!, fullName!, givenName!, familyName!, email!)
            
       
        gotoSignupAPI(fname: fullName!, lname: familyName!, email: email!, pwd: "", user_type: Constants.userTypeAPI[selectedUserType], auth_type: Constants.mailType[2])
            
    
        
        
        }
        

}
