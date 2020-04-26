

import UIKit
import SwiftyUserDefaults

class SplashVC: BaseViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0xff, green: 0x5c, blue: 0x5c)
        
        print("deviceTokenString: ", deviceTokenString)
    }
    
    @IBAction func onClickStart(_ sender: UIButton) {
        
        
        print("deviceTokenString: ", deviceTokenString)
        
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
                self.gotoVC()
            })
        })
        
        
    }
    
    func gotoVC(){
        
//        if ShareData.user_info.membership == "1" {
//            self.gotoTabVC("MainpageAfterNav")
//            
//        } else
            if staticValue.registerStatus == "1" {
            
           // self.dissmisAndGotoVC("SigninNav")
          self.gotoTabVC("MainbeforeLoginNav")
            
        } else {
            self.dissmisAndGotoVC("IntroductionVC")
        }
    }
}
