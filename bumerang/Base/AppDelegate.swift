//
//  AppDelegate.swift
//  bumerang
//
//  Created by RMS on 2019/9/3.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Photos
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import UserNotificationsUI
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import SwiftyStoreKit
import GoogleMaps

let FB_SCHEME = "fb516615525799024"
let GOOGLE_SCHEME  = "com.googleusercontent.apps.480946499113-6deojl08i8420vph3crmcsba8t2rv7rc"
var deviceTokenString = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
     
        GMSServices.provideAPIKey("AIzaSyBawAKyEG84sIR49zWqypF1FmsMBgL3HnI")
        //
        // for google signin
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        //GIDSignIn.sharedInstance()?.delegate = self
        
        // get permission of camera to take pictures
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied: break
        case .authorized: break
        case .restricted: break
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                } else {
                    print("Denied access to \(cameraMediaType)")
                }
            }
        default:
            break
        }
        
        // permission for photo library
        let photoLibraryStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoLibraryStatus {
            case .authorized:
                break
            //handle authorized status
            case .denied, .restricted :
                break
            //handle denied status
            case .notDetermined:
                // ask for permissions
                PHPhotoLibrary.requestAuthorization() { status in
                    switch status {
                    case .authorized:
                        break
                    // as above
                    case .denied, .restricted:
                        break
                    // as above
                    case .notDetermined:
                        break
                        // won't happen but still
                    default: break
                    }
                }
            default: break
        }
        

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .sound]//[.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
        application.registerForRemoteNotifications()

        storeKitSetup()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme == FB_SCHEME {
            return ApplicationDelegate.shared.application(
                application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation
            )
        } else {
            
            return (GIDSignIn.sharedInstance()?.handle(url))!
        }
        
    }
    
    @available(iOS 11.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        if url.scheme == FB_SCHEME {
            return ApplicationDelegate.shared.application(application, open: url, options: options)
        } else {
            
            return (GIDSignIn.sharedInstance()?.handle(url))!
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != [] {
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
        {
//            if let refreshedToken = InstanceID.instanceID().token() {
//                print("InstanceID token: \(refreshedToken)")
//            }
            let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
            var tokenString = ""

            for i in 0..<deviceToken.count {
                tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            }
//                        print("tokenString: \(tokenString)")
    }
    
    func storeKitSetup() {
            
            SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            self.inAppPurchaseValiator(purchase.productId)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    default:
                        break
                }
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

                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}


extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        let aps = userInfo["aps"] as? [AnyHashable : Any]
        let alertMessage = aps!["alert"] as? [AnyHashable : Any]
        let bodyMessage  = alertMessage!["body"] as! String
        let titleMessage = alertMessage!["title"] as! String
        
        if bodyMessage == "Start New Game" {
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoStreaming"), object: nil)
        }
        else {
            let alert = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: R_EN.string.OK, style: UIAlertAction.Style.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
}
//
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Messaging.messaging().subscribe(toTopic: "/topics/all")
        deviceTokenString = fcmToken
        print("fcmToken: ", fcmToken)
    }
}
