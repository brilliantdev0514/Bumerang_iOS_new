
import Foundation






class ProductModels {
    
    var rental_status : String!
    var owner_id    : String!
    var product_id  : String!
    var category    : String!
    var title       : String!
    var room_number : String!
    var heating     : String!
    var furbished   : String!
    var fuel_type   : String!
    var gear_type   : String!
    var door_number : String!
    var car_type    : String!
    var bed_capacity : String!
    var person_capacity : String!
    var captan      : String!
    var gender      : String!
    var size        : String!
    var color       : String!
    var price       : String!
    var deposit     : String!
    var description : String!
//    var image_url   : String!
    var address     : String!
    var lat         : String!
    var lng         : String!
    var zip_code    : String!
    var score       : String!
    var updated_at  : String!
    var created_at  : String!
//    var service_fee : String!
    var memberShipState: String!
    var date_unit   : String!
    var userinfo_fname : String!
    var userinfo_lname : String!
    var userinfo_avatar : String!
    var userinfo_rating : String!
    var userinfo_mailState : String!
    var userinfo_phoneState : String!
    var userinfo_googleState : String!
    var userinfo_faceState : String!
    
    var image_urls   : NSMutableArray!

        
    var placeHolerImage = "default_house_img"
    

    
    var image_url: String {
        get {
            let aObj = image_urls.object(at: 0)
                        return image_urls.object(at: 0) as! String
        }
    }
    
    
    init?(dictPro: [String: Any]){
    
//        guard let OwnerID = dictPro[ProductData.owner_id],
//            let ProductID = dictPro[ProductData.product_id]
//
//            else {
//                return nil
//        }
        self.owner_id    = "\(dictPro[ProductData.owner_id] ?? "")"
        self.product_id  = "\(dictPro[ProductData.product_id] ?? "")"
        self.category    = "\(dictPro[ProductData.category] ?? "")"
        self.title       = "\(dictPro[ProductData.title] ?? "")"
        self.room_number = "\(dictPro[ProductData.room_number] ?? "")"
        self.heating     = "\(dictPro[ProductData.heating] ?? "")"
        self.furbished   = "\(dictPro[ProductData.furbished] ?? "")"
        self.fuel_type   = "\(dictPro[ProductData.fuel_type] ?? "")"
        self.gear_type   = "\(dictPro[ProductData.gear_type] ?? "")"
        self.door_number = "\(dictPro[ProductData.door_number] ?? "")"
        self.car_type    = "\(dictPro[ProductData.car_type] ?? "")"
        self.bed_capacity = "\(dictPro[ProductData.bed_capacity] ?? "")"
        self.person_capacity = "\(dictPro[ProductData.person_capacity] ?? "")"
        self.captan     = "\(dictPro[ProductData.captan] ?? "")"
        self.gender     = "\(dictPro[ProductData.gender] ?? "")"
        self.size       = "\(dictPro[ProductData.size] ?? "")"
        self.color      = "\(dictPro[ProductData.color] ?? "")"
        self.price      = "\(dictPro[ProductData.price] ?? "")"
        self.deposit       = "\(dictPro[ProductData.deposit] ?? "")"
        self.description   = "\(dictPro[ProductData.description] ?? "")"
//        self.image_url     = "\(dictPro[[ProductData.image_url] ?? "")"
        self.address       = "\(dictPro[ProductData.address] ?? "")"
        self.lat           = "\(dictPro[ProductData.lat] ?? "")"
        self.lng           = "\(dictPro[ProductData.lng] ?? "")"
        self.zip_code      = "\(dictPro[ProductData.zip_code] ?? "")"
        self.rental_status = "\(dictPro[ProductData.rental_status] ?? "")"
        self.score         = "\(dictPro[ProductData.score] ?? "")"
//        self.service_fee   = dictPro[ProductData.service_fee]
        self.memberShipState = "\(dictPro[ProductData.membershipState] ?? "")"
        self.updated_at = "\(dictPro[ProductData.updated_at] ?? "")"
        self.created_at = "\(dictPro[ProductData.created_at] ?? "")"
        self.date_unit = "\(dictPro[ProductData.date_unit] ?? "")"
        
        if let img = dictPro["image_url"] as? String
        {
            self.image_urls     = NSMutableArray(array: [img])
        }else
        {
            self.image_urls     = (dictPro["image_url"] as! NSMutableArray)
        }
        
    }
    
    init(category: String, productId: String, productImg: String, title: String, rentState: String, lblTop1: String, lblTop2: String, lblMid: String, price: String, dateType: String) {

        self.category = category
        self.product_id = productId
//        self.image_url = productImg
        self.rental_status = rentState
        self.title = lblTop1
        self.furbished = lblTop2
        self.fuel_type = lblMid
        self.price = price
        self.date_unit = dateType
        
        //self.placeHolerImage = Constants.arrPlaceHolerImage[self.category]
    }
    
    init(categoryId: String, productId: String, productImg: String, title: String, priceVal: String,
         priceType:String, rentalStatus: String, updated_at: String, created_at: String) {
        self.category = categoryId
        self.product_id  = productId
//        self.image_url = productImg
        self.title     = title
        self.price  = priceVal
        self.date_unit = priceType
        self.rental_status  = rentalStatus
        self.updated_at = updated_at
        self.created_at = created_at
//        self.adsCost    = adsCost
        
//        self.placeHolerImage = Constants.arrPlaceHolerImage[categoryId]

    }
    
}

