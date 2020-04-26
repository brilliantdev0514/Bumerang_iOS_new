
import Foundation
import Firebase

struct Constants {
    
    static let SAVE_ROOT_PATH = "rms"
    
    struct refs {
        static let databaseRoot = Database.database().reference()

    }
    
    static let userType = ["Standart", "Kurumsal"]
    static let userTypeAPI = ["Standard", "Business"]
    static let mailType = ["Email", "Facebook", "Google"]
    
    static let categoryName = [
        "Kiralık Daireler", "Kiralık Araçlar", "Kiralık Karavanlar", "Kiralık Deniz Araçları", "Kiralık Giyim",
        "Kiralık Bisiklet", "Kiralık DSLR & Video", "Spore", "Kiralık Kamp Ekipmanları", "Kiralık Müzik Enstrümanları", "Diğer"
    ]
    
    static let cateImage = [
        "ic_flat_2",
        "ic_car_2",
        "ic_caravan_2",
        "ic_seavehicle_2",
        "ic_dress_2",
        "ic_bike_2",
        "ic_camera_2",
        "ic_camp_2",
        "ic_music_2",
        "ic_others_2"
    ]
    
    static let cataImg = [
        "ic_house1",    "ic_car",
        "ic_caravan",   "ic_sea_vehicle",
        "ic_dress_red", "ic_bike",
        "ic_camera",    "ic_kamp",
        "ic_music",     "ic_other"
    ]
    
    static let cataColor = [
        0xe4f011, 0x538edf,
        0x53dfc2, 0x73afe8,
        0xee5256, 0x835cd7,
        0xeea011, 0x56d44e,
        0xb792ea, 0xf994fb
    ]
    
    static let currencyUnit = "$"
    static let requestStateText = [
        "New Request",
        "Accepted Request",
        "Under Rent",
        "Cancelled Request",
        "Finished Request"
    ]
    
    static let arrPlaceHolerImage = [
        "default_house_img",
        "default_car_img",
        "default_car_img",
        "default_house_img",
        "default_dress_img",
        "default_bike_img",
        "default_camera_img",
        "default_house_img",
        "default_house_img",
        "default_house_img"
    ]
    
}

