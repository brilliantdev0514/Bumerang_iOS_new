
import Foundation
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON

struct PARAMS {
    
    
    //respons content
    static let EMAIL = "email"
    static let USERNAME = "username"
    static let PASSWORD = "password"
    static let DEVICE_TYPE = "device_type"
    static let USER_ID = "user_id"
    static let PIN = "pin"
    
    //request content
    static let RESULT_CODE = "result_code"
    static let USERINFO = "user_info"
    static let CODE_SUCESS = 200
    static let CODE_EMAIL_EXIST = 102
    static let CODE_USERNAME_EXIST = 103
    static let CODE_NO_USER = 104
    static let CODE_WRING_PWD = 105
    
    static let REQ_FIlES = "filename[]"
    static let REQ_REMOTE = "remote"
    static let REQ_PRICE = "price"
    static let REQ_USERID = "user_id"
    static let REQ_WATERMARK = "watermark"
    
    
    static let RES_WATERMARKURL = "watermark_url"
    static let RES_WATERMARKID = "watermark_id"
    static let RES_PRINTERLINK = "printer_link"
    static let RES_HELPLINK = "help_link"
    static let RES_MINPRICE = "min_price"
    static let RES_LINKINFO = "link_info"
    static let RES_URL = "url"
    static let RES_IMAGES = "images"
    
    static let RES_DATE = "date"
    static let RES_LINKID = "link_id"
    static let RES_BUYER = "buyer"
    static let RES_COMMISSION = "commission"
    static let RES_SALES = "sales"
    static let RES_BALENCE = "balance"
    
    static let ID = "id"
    static let WARTERMARK = "watermark"
    static let WARTERMARKS = "watermarks"
}

class ApiManager: NSObject {
    
    class func login(email : String, pwd : String, completion : @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + LOGIN
        let params = [
            PARAMS.EMAIL : email,
            PARAMS.PASSWORD : pwd,
            PARAMS.DEVICE_TYPE : 0] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    let userInfo = dict[PARAMS.USERINFO]
                    completion(true, userInfo)
                } else {
                    completion(false, result_code)
                }
            }
        }
    }
    
    class func signup(username : String, email: String, password: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + SIGNUP
        let params = [
            PARAMS.USERNAME : username,
            PARAMS.EMAIL : email,
            PARAMS.PASSWORD : password,
            PARAMS.DEVICE_TYPE : 0] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    let userInfo = dict[PARAMS.USERINFO]
                    completion(true, userInfo)
                } else {
                    completion(false, result_code)
                }
            }
        }
    }
    
    class func fogotPwd(email : String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + FORGOT
        let params = [
            PARAMS.EMAIL : email,
            PARAMS.DEVICE_TYPE : 0] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                completion(true, result_code)
                
            }
        }
    }
    
    class func changePassword(userId : String, password : String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + CHANGE_PWD
        let params = [
            PARAMS.USER_ID : userId,
            PARAMS.PASSWORD : password,
            PARAMS.DEVICE_TYPE : 0] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                completion(true, result_code)
                
            }
        }
    }
    
    class func changePaypalAddress(paypalAddr : String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + SAVE_PAYPAL
        let params = [
            PARAMS.USER_ID : String(Defaults[.userId]!),
            PARAMS.EMAIL : paypalAddr] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                completion(true, result_code)
                
            }
        }
    }
    
    class func changePIN(pin : String , completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + CHANGE_PIN
        let params = [
            PARAMS.EMAIL : String(Defaults[.email]!),
            PARAMS.PIN : pin] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                completion(true, result_code)
                
            }
        }
    }
    
    class func chooseWatermark (completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + GETWARTERMARK
        let params = [PARAMS.USER_ID : String(Defaults[.userId]!)] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    
                    let watermarks = dict[PARAMS.WARTERMARKS].arrayValue
                    
                    //                    let watermarks = dict["watermarks"].arrayValue
                    //set g_user.watermarks
                    for one in watermarks {
                        
                        let watermark = WatermarkModel(dict: one)
                        g_user.watermarks.append(watermark)
                    }
                    
                    completion(true, watermarks)
                    
                } else {
                    
                    completion(false, result_code)
                }
                
            }
        }
    }
    
    class func getSettings() {
        
        let URL = API + GETSETTINGS
        
        Alamofire.request(URL, method:.get).responseJSON { response in
            
            switch response.result {
                
            case .failure:
                break
                
            case .success(let data):
                
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    
                    g_printerLink = dict[PARAMS.RES_PRINTERLINK].stringValue
                    g_helpLink = dict[PARAMS.RES_HELPLINK].stringValue
                    g_minPrice = dict[PARAMS.RES_MINPRICE].floatValue
                }
            }
        }
    }
    
    class func uploadWatermark (imgFileName : String , completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API + UPLOADWARTERMARK
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("\(g_user.userId)".data(using:String.Encoding.utf8)!, withName: "user_id")
                multipartFormData.append(URL(fileURLWithPath: imgFileName), withName: "file")
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _): upload.responseJSON {
                    
                    response in
                    
                    switch response.result {
                        
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_CODE].intValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let url = dict[PARAMS.RES_WATERMARKURL].stringValue
                            let idx = dict[PARAMS.RES_WATERMARKID].intValue
                            
                            let watermark = WatermarkModel(watermarkId: idx, imgUrl: url, isHidden: false)
                            g_user.watermarks.append(watermark)
                            completion(true, result_code)
                            
                        } else {
                            completion(false, result_code)
                        }
                    }
                    }
                case .failure(let encodingError):
                    
                    print(encodingError)
                    completion(false, nil)
                }
        })
    }
    
    class func uploadFiles (price : Float, images:[String], completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API + UPLOADFILES
        let watermark = Defaults[.watermarkID]!
        var remote : JSON = []
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("\(g_user.userId)".data(using:String.Encoding.utf8)!, withName: PARAMS.REQ_USERID)
                multipartFormData.append("\(price)".data(using:String.Encoding.utf8)!, withName: PARAMS.REQ_PRICE)
                multipartFormData.append("\(watermark)".data(using:String.Encoding.utf8)!, withName: PARAMS.REQ_WATERMARK)
                
                for one in images {
                    if !one.starts(with: HOST) {      // local
                        multipartFormData.append(URL(fileURLWithPath: one), withName: PARAMS.REQ_FIlES)
                    } else {    // remote
                        remote.arrayObject?.append(one)
                    }
                }
                
                if let remotefiles = remote.arrayObject {
                    
                    let strRemotes = "\(remotefiles)"
                    multipartFormData.append(strRemotes.data(using:String.Encoding.utf8)!, withName: PARAMS.REQ_REMOTE)
                }
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .failure: completion(false, nil)
                        case .success(let data):
                            let dict = JSON(data)
                            let result_code = dict[PARAMS.RESULT_CODE].intValue
                            
                            if result_code == PARAMS.CODE_SUCESS {
                                
                                let linkInfo = dict[PARAMS.RES_LINKINFO]
                                completion(true, linkInfo)
                            }
                            else { completion(false, result_code) }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completion(false, nil)
                }
        })
    }
    
    class func getRemoteFiles (completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + GETREMOTEFILES
        
        let params = [PARAMS.USERNAME : String(Defaults[.username]!)] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
            case .failure: completion(false, nil)
            case .success(let data):
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    
                    let remotes = dict[PARAMS.RES_IMAGES].arrayValue
                    
                    //set g_user.remotes
                    for one in remotes {
                        
                        g_user.remotes.append(one.stringValue)
                    }
                    
                    completion(true, remotes)
                    
                } else { completion(false, result_code) }
            }
        }
    }
    
    class func getSalsHistory (completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + SALSHISTORY
        
        let params = [PARAMS.REQ_USERID : String(Defaults[.userId]!)] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
            case .failure: completion(false, nil)
            case .success(let data):
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    //let sales = dict[PARAMS.RES_SALES].arrayValue
                    completion(true, dict)
                    
                } else { completion(false, result_code) }
            }
        }
    }
    
    class func getMyLink (completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let URL = API + MYLINKS
        
        let params = [PARAMS.REQ_USERID : String(Defaults[.userId]!)] as [String : Any]
        
        Alamofire.request(URL, method:.post, parameters:params).responseJSON { response in
            
            switch response.result {
            case .failure: completion(false, nil)
            case .success(let data):
                let dict = JSON(data)
                let result_code = dict[PARAMS.RESULT_CODE].intValue
                
                if result_code == PARAMS.CODE_SUCESS {
                    let sales = dict["links"].arrayValue
                    completion(true, sales)
                    
                } else { completion(false, result_code) }
            }
        }
    }
    
}
