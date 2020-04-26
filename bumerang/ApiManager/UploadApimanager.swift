//
//  UploadApimanager.swift
//  bumerang
//
//  Created by RMS on 2019/9/14.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON

class UploadApimanager : NSObject {
    
    class func gotoUploadCarApi(title: String, fuel : String, gear: String, door: String, carType : String, priceType : String, price : String, deposit : String, description : String, image : String, addr : String, lat : String, lng : String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_CAR + UPLOAD_CAR
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(fuel.data(using:String.Encoding.utf8)!, withName: PARAMS.FUEL_TYPE)
                multipartFormData.append(gear.data(using:String.Encoding.utf8)!, withName: PARAMS.GEAR_TYPE)
                multipartFormData.append(door.data(using:String.Encoding.utf8)!, withName: PARAMS.DOOR_NUMBER)
                multipartFormData.append(carType.data(using:String.Encoding.utf8)!, withName: PARAMS.CAR_TYPE)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(deposit.data(using:String.Encoding.utf8)!, withName: PARAMS.DEPOSIT)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(addr.data(using:String.Encoding.utf8)!, withName: PARAMS.ADDRESS)
                multipartFormData.append("\(lat)".data(using:String.Encoding.utf8)!, withName: PARAMS.LOCATION_LAT)
                multipartFormData.append("\(lng)".data(using:String.Encoding.utf8)!, withName: PARAMS.LOCATION_LNG)
                
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                        case .failure: completion(false, nil)
                        case .success(let data):
                            let dict = JSON(data)
                            let result_code = dict[PARAMS.RESULT_MSG].stringValue
                            
                            if result_code == PARAMS.CODE_SUCESS {
                                let uploadInfo = dict[PARAMS.UPLOADINFO]
                                completion(true, uploadInfo)
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
    
    class func gotoUploadFlatApi(title: String, roomnum : String, heating: String, furbished:String, priceType: String, price : String, deposit: String, description : String, image: String, addr : String, lat : String, lng : String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_CAR + UPLOAD_CAR
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(deposit.data(using:String.Encoding.utf8)!, withName: PARAMS.DEPOSIT)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(addr.data(using:String.Encoding.utf8)!, withName: PARAMS.ADDRESS)
                multipartFormData.append(lat.data(using:String.Encoding.utf8)!, withName: PARAMS.LOCATION_LAT)
                multipartFormData.append(lng.data(using:String.Encoding.utf8)!, withName: PARAMS.LOCATION_LNG)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                multipartFormData.append(roomnum.data(using:String.Encoding.utf8)!, withName: PARAMS.ROOM_NUMBER)
                multipartFormData.append(heating.data(using:String.Encoding.utf8)!, withName: PARAMS.HEATING)
                multipartFormData.append(furbished.data(using:String.Encoding.utf8)!, withName: PARAMS.FURBISHED)
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    class func gotoUploadCaravanApi(title: String, bednum : String, fuel: String, priceType: String, price : String, deposit: String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_CARAVAN + UPLOAD_CARAVAN
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(deposit.data(using:String.Encoding.utf8)!, withName: PARAMS.DEPOSIT)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                multipartFormData.append(bednum.data(using:String.Encoding.utf8)!, withName: PARAMS.BED_CAPACITY)
                multipartFormData.append(fuel.data(using:String.Encoding.utf8)!, withName: PARAMS.FUEL_TYPE)
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadSeavehicleApi(title: String, person : String, captan: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_SEAVEHICLE + UPLOAD_SEAVEHICLE
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                multipartFormData.append(person.data(using:String.Encoding.utf8)!, withName: PARAMS.PERSON_CAPACITY)
                multipartFormData.append(captan.data(using:String.Encoding.utf8)!, withName: PARAMS.CAPTAN)
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadClothApi(title: String, gender: String, size: String, color: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_CLOTH + UPLOAD_CLOTH
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                multipartFormData.append(gender.data(using:String.Encoding.utf8)!, withName: PARAMS.GENDER)
                multipartFormData.append(size.data(using:String.Encoding.utf8)!, withName: PARAMS.SIZE)
                multipartFormData.append(color.data(using:String.Encoding.utf8)!, withName: PARAMS.COLOR)
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadBikeApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_BIKE + UPLOAD_BIKE
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadCameraApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_CAMERA + UPLOAD_CAMERA
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadSporeApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_SPORE + UPLOAD_SPORE
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadKampApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_KAMP + UPLOAD_KAMP
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    class func gotoUploadMusicApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_MUSIC + UPLOAD_MUSIC
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
    class func gotoUploadOtherApi(title: String, priceType: String, price : String, description : String, image: String, completion: @escaping (_ success: Bool, _ response : Any?) -> ()) {
        
        let requestURL = API_OTHER + UPLOAD_OTHER
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(title.data(using:String.Encoding.utf8)!, withName: PARAMS.TITLE)
                multipartFormData.append(Defaults[.userId].data(using:String.Encoding.utf8)!, withName: PARAMS.OWNER_ID)
                multipartFormData.append(priceType.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_TYPE)
                multipartFormData.append(price.data(using:String.Encoding.utf8)!, withName: PARAMS.PRICE_VAL)
                multipartFormData.append(description.data(using:String.Encoding.utf8)!, withName: PARAMS.DESCRIPTION)
                multipartFormData.append(URL(fileURLWithPath: image), withName: PARAMS.UPLOAD_IMAGE)
                
                
        },
            to: requestURL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _): upload.responseJSON { response in
                    
                    switch response.result {
                    case .failure: completion(false, nil)
                    case .success(let data):
                        let dict = JSON(data)
                        let result_code = dict[PARAMS.RESULT_MSG].stringValue
                        
                        if result_code == PARAMS.CODE_SUCESS {
                            let uploadInfo = dict[PARAMS.UPLOADINFO]
                            completion(true, uploadInfo)
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
    
    
}
