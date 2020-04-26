import UIKit
import SwiftyStoreKit
import FirebaseAuth
class SelectMembershipVC: BaseViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func purchaseDone() {
        
        staticValue.memberShipVar = "1"
        Auth.auth().createUser(withEmail: ShareData.user_info.email, password: ShareData.user_info.pwd) { user, error in
        if error == nil {
            Auth.auth().signIn(withEmail: ShareData.user_info.email, password: ShareData.user_info.pwd)
        let userid = Auth.auth().currentUser?.uid
            let storingDict:[String:String] = [ShareData.Tuserid: userid!, ShareData.Tuserfirstname: ShareData.user_info.first_name, ShareData.Tuserlastname: ShareData.user_info.last_name, ShareData.Tuseremail: ShareData.user_info.email, ShareData.Tuserpassword: ShareData.user_info.pwd, ShareData.TgoogleEmail: "", ShareData.TfacebookEmail: "", ShareData.TuserType: Constants.userType[1], ShareData.TuserMemberShip: "1", ShareData.Tuserphone: "", ShareData.Tuserphotoid: "", ShareData.TuserScore: "", ShareData.TuserAddress: "", ShareData.TuserCity: "", ShareData.Tuserlatitude: "", ShareData.Tuserlongitude: "", ShareData.TuserEmailVerified: "", ShareData.TuserPhoneVerified: "", ShareData.TuserIdVerfied: "", ShareData.TuserUpdatedAt: "", ShareData.TuserCreatedAt: ""]
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
    }
 
    
    func purchaseProduct () {
        
        showHUD()
        
        let productId = "com.berkapp.bumerang"
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                self.inAppPurchaseValiator(productId)
                
            } else if case .error(let error) = result {
                
                self.showAlertDialog(title: "In App Purchase", message: error.localizedDescription, positive: "Canel", negative: nil)
                print(result)
                self.hideHUD()
            }
        }
    }
    
    func inAppPurchaseValiator(_ productID: String) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "523549eb600a4ce282f4708d1bbd3343")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set([productID])
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt)

                self.hideHUD()
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                    self.purchaseDone()
                case .expired(let expiryDate, let items):
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                self.hideHUD()
            }
        }
    }
    
    @IBAction func toNext(_ sender: Any) {
        
        purchaseProduct()
        //purchaseDone()
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
