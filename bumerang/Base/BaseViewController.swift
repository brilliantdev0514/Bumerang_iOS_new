
import UIKit
import SwiftyUserDefaults
import Toast_Swift
import NotificationCenter
import ALLoadingView
import Firebase
import FirebaseAuth
import FirebaseDatabase

var selectedUserType = 0
var selectedCategoryID = -1
var selectedMembership = -1

class BaseViewController: UIViewController, AddProductSucessVCDelegate {
            
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    var darkView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func gotoAddProductSucessVC () {
        self.storyboard?.instantiateInitialViewController()?.dismiss(animated: true, completion: nil)
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "AddProductSucessVC") as! AddProductSucessVC
        
        toVC.delegate = self
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: false, completion: nil)
    }
    
    func gotoMainBeforeVC () {
        self.storyboard?.instantiateInitialViewController()?.dismiss(animated: true, completion: nil)
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "MainbeforeLoginNav")
        
        toVC!.modalPresentationStyle = .fullScreen
        self.present(toVC!, animated: false, completion: nil)
    }
    
    func gotoTabVC (_ nameNavVC: String) {
        self.dismiss()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: nameNavVC) as! UINavigationController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    //MARK: - go to profile VC
    func gotoMyInfoVC(oneProduct : ProductModels?) {
        Database.database().reference().child("user").child(oneProduct!.owner_id).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let membershipStatus = value?["membership"] as? String ?? ""
            if (membershipStatus == "1") {
                self.setTransitionType(.fromLeft)
                let toVC = self.storyboard?.instantiateViewController( withIdentifier: "BusinessInfoVC") as! BusinessInfoVC
                toVC.oneProduct = oneProduct
                toVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(toVC, animated: true)
            } else {
                self.setTransitionType(.fromLeft)
                let toVC = self.storyboard?.instantiateViewController( withIdentifier: "StandardInfoVC") as! StandardInfoVC
                toVC.oneProduct = oneProduct
                toVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(toVC, animated: true)
            }
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // dissmis current VC and Goto one VC
    func dissmisAndGotoVC (_ nameVC: String) {
        
        self.dismiss()
        self.gotoNewVC(nameVC)
    }
    
    //Goto new VC
    func gotoNewVC (_ nameVC: String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: nameVC)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    //dissmis current VC
    func dismiss() {
        self.storyboard?.instantiateInitialViewController()?.dismiss(animated: true, completion: nil)
    }
    
    // load one vc on current NavigationScreen
    func gotoNavigationScreen(_ nameVC: String) {
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        
        toVC!.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(toVC!, animated: true)
    }
    // load one vc on current NavigationScreen
    func gotoNavigationScreen(_ nameVC: String, direction : CATransitionSubtype) {
        
        setTransitionType(direction)
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        
        toVC!.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(toVC!, animated: true)
    }
    
    //set dispaly effect
    func setTransitionType(_ direction : CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    func setTextFieldOfAlertdialog(textField : UITextField, placeHolder :String){
        
        textField.placeholder = placeHolder
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        
    }
    
    func showAlertDialog(title: String!, message: String!, positive: String?, negative: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //preferredStyle: .actionSheet
        if (positive != nil) {
            
            alert.addAction(UIAlertAction(title: positive, style: .default, handler: nil))
        }
        
        if (negative != nil) {
            
            alert.addAction(UIAlertAction(title: negative, style: .default, handler: nil))
        }
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func showError(_ message: String!) {

        showAlertDialog(title: R_EN.string.ERROR, message: message, positive: R_EN.string.OK, negative: nil)
    }

    func showAlert(_ title: String!) {
        showAlertDialog(title: title, message: "", positive: R_EN.string.OK, negative: nil)
    }
    
    func showHUD() {
        
        showHUDWithTitle(title: "")
    }
    
    func showHUDWithTitle(title: String) {
        
        if title == "" {
            ProgressHUD.show()
        } else {
            ProgressHUD.showWithStatus(string: title)
        }
    }
    
    func showSuccess() {
        
        DispatchQueue.main.async(execute:  {
            ProgressHUD.showSuccessWithStatus(string: R_EN.string.SUCCESS)
        })
    }
    
    // hide loading view
    func hideHUD() {
        
        ProgressHUD.dismiss()
    }
    
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func showToast(_ message : String, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = ToastManager.shared.position) {
    
        self.view.makeToast(message, duration: duration, position: position)
    }
    
    var blackView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.backgroundColor = UIColor.init(white: 0.60, alpha: 0.5)
        view.backgroundColor = UIColor.black
        
        return view
    }()
    
    func showToastProgress(){
        
        //self.navigationController?.isNavigationBarHidden = true
        
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(darkView)
        self.view.makeToastActivity(ToastPosition.center)
    }
    
    func hideToastProgress(){
        //self.navigationController?.isNavigationBarHidden = false
        darkView.removeFromSuperview()
        self.view.hideToastActivity()
    }
    
    
    func showALLoadingViewWithTitle(title: String, type: ALLVType = .basic, mode:ALLVWindowMode = .windowed ) {
        
        ALLoadingView.manager.resetToDefaults()
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        ALLoadingView.manager.animationDuration = 0.5
        ALLoadingView.manager.itemSpacing = 10.0
        ALLoadingView.manager.windowRatio = 0.3
        ALLoadingView.manager.messageText = title
        ALLoadingView.manager.messageFont = UIFont.systemFont(ofSize: 18)
        ALLoadingView.manager.showLoadingView(ofType: type, windowMode: mode)
        //ALLoadingView.manager.showLoadingView(ofType: type, windowMode: .some(.windowed))
    }
    
    // hide loading view
    func hideALLoadingView() {
        
        ALLoadingView.manager.hideLoadingView()
        
        
    }
    
    // MARK: AddProductSucessVCDelegate
    func myVCDidFinish() {

        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension DefaultsKeys {

    static let userId = DefaultsKey<String?>("userId", defaultValue: "")
    static let email = DefaultsKey<String?>("email", defaultValue: "")
    static let pwd = DefaultsKey<String?>("pwd", defaultValue: "")
    static let firstname = DefaultsKey<String?>("firstname", defaultValue: "")
    static let lastname = DefaultsKey<String?>("lastname", defaultValue: "")
    static let userType = DefaultsKey<String?>("userType")
    static let registerState = DefaultsKey<String?>("registerState", defaultValue: "0")
    static let rememberState = DefaultsKey<String?>("rememberState", defaultValue: "0")
 
}

