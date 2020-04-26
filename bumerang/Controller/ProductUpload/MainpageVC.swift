
import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import UPCarouselFlowLayout
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainpageVC: BaseViewController {
    
    @IBOutlet weak var ui_searchBar: UISearchBar!
    
    @IBOutlet weak var searchbar: UITextField!
    
    @IBOutlet weak var ui_collection_cat: UICollectionView!
//    @IBOutlet weak var ui_collection_ads: UICollectionView!
    @IBOutlet weak var ui_collection_filter: UICollectionView!
    @IBOutlet weak var ui_collection_prod: UICollectionView!
    
    @IBOutlet weak var ui_viewEmptyProduct: UIView!
    @IBOutlet weak var ui_view_coll_ads: UIView!
    @IBOutlet weak var ui_view_coll_filter: UIView!
    @IBOutlet weak var ui_lbl_chatnum: UILabel!
    @IBOutlet weak var ui_lbl_boxnum: UILabel!
    
    var catagoryData = [MainCatagoryModel]()
    var adsData     = [MainAdsModel]()
    var productData = [ProductModels]()
    var allProductData = [ProductModels]()
    
    var allFilterData  = [[MainFilterModel]()]
    var oneFilterCell = [MainFilterModel]()
    
    var priOffsetY : CGFloat = 0
    var currentCatagory = 0
    var currentAdsPage = 0
    var adsHeight : CGFloat = 0
    var preSelectedCatagoryId = -1
    
    let adsImage = "ads_background"
    let adsPostion = 5
    
    var countCallApi = 0
    
    
    
    // product filter
    
    var roomNum = ""
    var heating = ""
    var gender = ""
    var size = ""
    var color = ""
    var furbished = ""
    var fuel = ""
    var gear = ""
    var carType = ""
    var bedNum = ""
    var personNum = ""
    var captan = ""
    var price = ""
    var priceType = ""
    var doorNum = ""
    var deposit = ""
    
//    var pageSize: CGSize {
//        let layout = ui_collection_ads.collectionViewLayout as! UPCarouselFlowLayout
//        var pageSize = layout.itemSize
//        pageSize.width += layout.minimumLineSpacing
//        return pageSize
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingData()
        
        checkMessage()
//        searchbar.setLeftIcon(UIImage(named: "searchicin.png")!)
//        searchbar.clipsToBounds = true
//        searchbar.cornerRadius = searchbar.height/2
        loadCatagoryData()
        setFilterAllData()
        gotoProductAdsApi(catagoryId: 0, pageNum: 1, isFirst: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        ui_collection_cat.reloadData()
        ui_collection_cat.layoutIfNeeded()
        //setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Geri", style:.plain, target:nil, action:nil)
    }
    func checkMessage() {
        Database.database().reference().child("notification").child(ShareData.user_info.userId).observe(.value, with: { (SnapShot) in
            if !SnapShot.exists() {
                self.self.ui_lbl_chatnum.isHidden = true
            } else{
                self.ui_lbl_chatnum.isHidden = false
            }
        })
        
        
    }
    func loadingData(){
        let uid = Auth.auth().currentUser?.uid ?? "0"
        ShareData.dbUserRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            if !snapshot.exists() {
                // handle data not found
                return
            }
            let userData = snapshot.value as! [String: String]
//          Users user = Users.init(dict: value)
          ShareData.user_info = Users.init(dict: userData)
            staticValue.ownerType = ShareData.user_info.user_type
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // name and email..upddate
        
       
    }

    
    func loadCatagoryData() {
        
        catagoryData.removeAll()
        for i in 0 ..< Constants.cateImage.count  {
            
            let state = (i == currentCatagory ? true : false)
            let one = MainCatagoryModel(
                catagoryId: "\(i)",
                catatoryImg: Constants.cateImage[i],
                catagoryColor: Constants.cataColor[i],
                catagoryState: state
            )
            catagoryData.append(one)
        }
        
        ui_collection_cat.reloadData()
    }
    
    let blackview = UIButton()
    
    
    
    @IBAction func editingbegin(_ sender: Any) {
        
        self.view.addSubview(blackview)
        
        blackview.alpha = 0.8
        
        blackview.backgroundColor = #colorLiteral(red: 0.7863075658, green: 0.8574629934, blue: 1, alpha: 1)
        
        blackview.frame = self.view.bounds
        
        self.view.bringSubviewToFront(searchbar)
        
        blackview.addTarget(self, action: #selector(tapblack) , for: .touchUpInside)
        
        
        
        
    }
    
    @objc func tapblack (){
        
        blackview.alpha = 0
        searchbar.endEditing(true)
        
    }
    
    
    func setFilterAllData(){
        
        allFilterData.removeAll()
        oneFilterCell.removeAll()
        
        var fuel = FuelTypeOption().values_en;
        var fuelID = FuelTypeOption().ids;
        
        fuel.insert("Yakıt", at: 0)
        fuelID.insert(0, at: 0)
        
        var price = PriceFlatOption().values
        var priceID = PriceFlatOption().ids;
        
        price.insert("Fiyat", at: 0)
        priceID.insert(0, at: 0)
        
        var deposit = BoolTypeOption().values
        var DepositID = BoolTypeOption().ids;
        
        deposit.insert("Depozito", at: 0)
        DepositID.insert(0, at: 0)
        
        for index in 1 ..< 12 {
            
            switch index {
               case 2:
                   
                var rommNumber = RoomNumberOption().values;
                var rommNumberID = RoomNumberOption().ids;
                
                rommNumber.insert("Oda Sayısı", at: 0)
                rommNumberID.insert(0, at: 0)
                oneFilterCell.append(MainFilterModel(titleLbl: rommNumber[0], filterLbls: rommNumber, filterIDs: rommNumberID, cellWidth: CGFloat(120), logo: UIImage(named: "Room Number")!) )
                   
                var heating = HeatingOption().values_en;
                var heatingID = HeatingOption().ids;
                
                heating.insert("Isıtma", at: 0)
                heatingID.insert(0, at: 0)
                oneFilterCell.append(MainFilterModel(titleLbl: heating[0], filterLbls: heating, filterIDs: heatingID, cellWidth: CGFloat(140), logo: UIImage(named: "Heating Type")!))
                   

                var furbished = BoolTypeOption().values;
                var furbishedID = BoolTypeOption().ids;
                
                furbished.insert("Eşyalı", at: 0)
                furbishedID.insert(0, at: 0)
                oneFilterCell.append(MainFilterModel(titleLbl: furbished[0], filterLbls: furbished, filterIDs: furbishedID, cellWidth: CGFloat(90), logo: UIImage(named: "Furbished")!))
                
                oneFilterCell.append(MainFilterModel(titleLbl: price[0], filterLbls: price, filterIDs: priceID, cellWidth: CGFloat(110), logo: UIImage(named: "Deposit")!))
                oneFilterCell.append(MainFilterModel(titleLbl: deposit[0], filterLbls: deposit, filterIDs: DepositID, cellWidth: CGFloat(70), logo: UIImage(named: "Deposit")!))
                   
               case 3:
                   
                   oneFilterCell.append(MainFilterModel(titleLbl: fuel[0], filterLbls: fuel, filterIDs: fuelID, cellWidth: CGFloat(120), logo: UIImage(named: "Fuel")!))

                var gear = GearOption().values;
                var gearID = GearOption().ids;
                
                gear.insert("Vites", at: 0)
                gearID.insert(0, at: 0)
                   oneFilterCell.append(MainFilterModel(titleLbl: gear[0], filterLbls: gear, filterIDs: gearID, cellWidth: CGFloat(120), logo: UIImage(named: "Gear")!))

                var door = RoomNumberOption().values;
                var doorID = RoomNumberOption().ids;
                
                door.insert("Kapı Sayısı", at: 0)
                doorID.insert(0, at: 0)
                
                   oneFilterCell.append(MainFilterModel(titleLbl: door[0], filterLbls: door, filterIDs: doorID, cellWidth: CGFloat(110), logo: UIImage(named: "Door Number")!))
                   
                var car = CarTypeOption().values;
                var carID = CarTypeOption().ids;
                
                car.insert("Araç Tipi", at: 0)
                carID.insert(0, at: 0)
                
                   oneFilterCell.append(MainFilterModel(titleLbl: car[0], filterLbls: car, filterIDs: carID, cellWidth: CGFloat(90), logo: UIImage(named: "Car Type")!))
                   
                   
                   oneFilterCell.append(MainFilterModel(titleLbl: price[0], filterLbls: price, filterIDs: priceID, cellWidth: CGFloat(100), logo: UIImage(named: "Deposit1")!))
                
                   oneFilterCell.append(MainFilterModel(titleLbl: deposit[0], filterLbls: deposit, filterIDs: DepositID, cellWidth: CGFloat(70), logo: UIImage(named: "Deposit")!))
               case 4:
                   
                var bed = RoomNumberOption().values;
                var bedID = RoomNumberOption().ids;
                
                bed.insert("Yatak Kapasitesi", at: 0)
                bedID.insert(0, at: 0)
                
                   oneFilterCell.append(MainFilterModel(titleLbl: bed[0], filterLbls: bed, filterIDs: bedID, cellWidth: CGFloat(120), logo: UIImage(named: "Bed Capacity")!))
                   
                
                   oneFilterCell.append(MainFilterModel(titleLbl: fuel[0], filterLbls: fuel, filterIDs: fuelID, cellWidth: CGFloat(120), logo: UIImage(named: "Fuel")!))
                   
                   oneFilterCell.append(MainFilterModel(titleLbl: price[0], filterLbls: price, filterIDs: priceID, cellWidth: CGFloat(100), logo: UIImage(named: "Deposit")!))
            
                   oneFilterCell.append(MainFilterModel(titleLbl: deposit[0], filterLbls: deposit, filterIDs: DepositID, cellWidth: CGFloat(70), logo: UIImage(named: "Deposit")!))
                
               
               default: break
               }
            
            allFilterData.append(oneFilterCell)
            oneFilterCell.removeAll()
        }
        
        
    }

    func loadFilterData(_ catagoryID: Int) {
        
        oneFilterCell.removeAll()
        oneFilterCell = allFilterData[catagoryID]
        
        setVisablity(category: 0)
        ui_collection_filter.reloadData()
        ui_collection_filter.layoutIfNeeded()
    }
    
    @IBAction func onClickMyLocation(_ sender: Any) {
        self.showToast("123123")
    }
    
    @IBAction func onClickPluse(_ sender: Any) {
        self.gotoNavigationScreen("CatagorySelectVC", direction: .fromLeft)
    }
    
    @IBAction func onClickChart(_ sender: Any) {
        
        self.gotoTabVC("MainpageAfterNav")
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        self.gotoNavigationScreen("ChatListNav")
        Database.database().reference().child("notification").child(ShareData.user_info.userId).removeValue()

    }
    //MARK:- search by city
    @IBAction func onClickRend(_ sender: Any) {
//        self.gotoTabVC("RentHistoryNav")
        let toSearch = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        toSearch.delegate = self
        self.modalPresentationStyle = .fullScreen
        self.present(toSearch, animated: true, completion: nil)

    }
    
    @IBAction func onClickMyProfile(_ sender: Any) {
        if (ShareData.user_info.membership == "1") {
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoVC") as! BusinessInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        } else {
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "StandardInfoVC") as! StandardInfoVC
            toVC.modalPresentationStyle = .fullScreen
            self.present(toVC, animated: true, completion: nil)
        }
    }
    
    func showADSDataofCatagory(_ responseAdaData: [JSON], _ categoryId: Int, _ pageNum :Int = 1) {
     
//        let countADSData = adsData.count
//        if countADSData > 0, adsData[countADSData-1].adsImg == adsImage {
//            adsData.remove(at: countADSData-1)
//        }
        
        for one in responseAdaData {
            let oneAds = MainAdsModel(dict: one)
            self.adsData.append(oneAds)
        }

        
        if categoryId < 5 && pageNum == 1 {
            let one = MainAdsModel(adsId: adsData.count, adsImg: adsImage, adsTitle: "Click here to advertise", adsDescription: "")
            if self.adsData.count < 5 {
                adsData.append(one)
            } else {
                adsData.insert(one, at: 4)
            }
            
//            adsData.append(MainAdsModel(adsId: adsData.count, adsImg: adsImage, adsTitle: "", adsDescription: ""))
        }
//
//        self.addAdsCard(categoryId - 1)
        
//        if self.adsData.count == 0 {
//            self.ui_collection_ads.isHidden = true
//        } else {
//            self.ui_collection_ads.isHidden = false
//        }

    }
    
//    func addAdsCard(_ categoryID : Int){
//        
//        if categoryID < 5 {
//            if adsData[adsData.count-1].adsImg == adsImage {
//                adsData.remove(at: adsData.count-1)
//            }
//            
//            adsData.append(MainAdsModel(adsId: adsData.count, adsImg: adsImage, adsTitle: "", adsDescription: ""))
//        } else {}
//    }
    
    func setVisablity(category: Int) {

        if oneFilterCell.count == 0 {
            
            self.ui_collection_filter.visiblity(gone: true, dimension: 0.0)
            self.ui_view_coll_filter.visiblity(gone: true, dimension: 0.0)
            
        } else {
            
            self.ui_collection_filter.visiblity(gone: false, dimension: 50)
            self.ui_view_coll_filter.visiblity(gone: false, dimension: 55)
        }
    }
//
    func setEmptyProductViewVisablity(_ isSucess: Bool, state: String ) {
        if isSucess == true {
            if state == "0" { ui_viewEmptyProduct.isHidden = false }
            else { ui_viewEmptyProduct.isHidden = true }
        } else {
            if state == "" { self.showToast(R_EN.string.CONNECT_FAIL) }
            else {
                ui_viewEmptyProduct.isHidden = false
                self.showToast(state)
            }
        }
    }
    
    func setEmptyFilterContent(_ pageNum: Int = 1) {
        roomNum = ""
        heating = ""
        gender = ""
        size = ""
        color = ""
        furbished = ""
        fuel = ""
        gear = ""
        carType = ""
        bedNum = ""
        personNum = ""
        captan = ""
        price = ""
        priceType = ""
        doorNum = ""
        deposit = ""
    }
    
    
    

    
    
    
    
    
    
    func gotoMyAdsAdd(){

        self.gotoNavigationScreen("AddAdsInfoVC", direction: .fromRight)
    }
    
    func gotoProductAdsApi(catagoryId : Int, pageNum : Int, isFirst: Bool) {
        
        if preSelectedCatagoryId == catagoryId, pageNum == 1 {
            return
        }
        
        self.showALLoadingViewWithTitle(title: "İlanlar yükleniyor", type: .messageWithIndicator )
        
        if pageNum == 1 {
            self.adsData.removeAll()
            self.productData.removeAll()
            self.allProductData.removeAll()
        }
        
        switch catagoryId {
            case 0:
                roomNum = ""
                heating = ""
            default:
                roomNum = ""
        }
        
         ProductData.dbProRef.observe(DataEventType.value, with: { (snapshot) in
                    self.hideALLoadingView()
                    self.productData.removeAll()
                        self.allProductData.removeAll()
                    let productList = snapshot.children.allObjects as! [DataSnapshot]
                    for data in productList{
                        if let data = data.value as? [String: Any] {
                            
                            let oneProductModel = ProductModels.init(dictPro: data)
                            
                            if oneProductModel!.category != nil {
                            
                                let catagoryNum = Int(oneProductModel!.category)
                                if isFirst {
                                    self.productData.append(oneProductModel!)
                                    self.allProductData.append(oneProductModel!)
                                }
                                else if catagoryId != 0 && catagoryId == catagoryNum {
                                    self.productData.append(oneProductModel!)
                                    self.allProductData.append(oneProductModel!)
                                }
//                                else if catagoryId == catagoryNum {
//                                    self.productData.append(oneProductModel!)
//                                    self.allProductData.append(oneProductModel!)
//                                }
                            }
                        }
                    }
        //            advantage data
                                    
                   self.countCallApi = 0
                   self.setEmptyProductViewVisablity(true, state : "\(productList.count)")
                    self.ui_collection_prod.reloadData()
//                   self.ui_collection_ads.reloadData()
            
                            if !isFirst && pageNum == 1 {
                                self.loadFilterData(catagoryId)
                            } else {
                                self.setVisablity(category: 0)
            }

                  // ...
                })

        if !isFirst {
            preSelectedCatagoryId = catagoryId
        }
    }
    
    func gotoProdauctdetailpageVC( productNum : Int) {
        
        var nameVC = ""
        if productData[productNum].category != nil {
        
            let catagoryNum = Int(productData[productNum].category)        
            switch  catagoryNum {
            case 1 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                toVC.oneProduct = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 2 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
                toVC.oneProduct = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 3:
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CaravanDetailVC") as! CaravanDetailVC
                toVC.oneProduct = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 4 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "SeaVehicleDetailVC") as! SeaVehicleDetailVC
                toVC.oneProduct = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)

            case 5 :
                
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ClothDetailVC") as! ClothDetailVC
                toVC.oneProduct = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)
            case 6:
                
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "BikeDetailVC") as! BikeDetailVC
                toVC.oneProduct_ = productData[productNum]
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 7 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
                toVC.oneProduct = productData[productNum]
                toVC.navigationTitle = "Kiralık DSLR & Video"
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 8 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
                toVC.oneProduct = productData[productNum]
                toVC.navigationTitle = "Kiralık Kamp Ekipmanları"
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 9 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
                toVC.oneProduct = productData[productNum]
                toVC.navigationTitle = "Kiralık Müzik Enstrümanları"
                self.navigationController?.pushViewController(toVC, animated: true)
                
            case 10 :
                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
                toVC.oneProduct = productData[productNum]
                toVC.navigationTitle = "Diğer"
                self.navigationController?.pushViewController(toVC, animated: true)
                
            default:
                nameVC = ""
            }
            
            if nameVC.isEmpty {
                return
            }
        }
    }

    func filterSearchTextByCity(selectedVal : String) {
    
        self.productData.removeAll()
        for oneProductModel in allProductData{
            
            if selectedVal != "" {
            
                if oneProductModel.address.contains(selectedVal)  {
                    
                    self.productData.append(oneProductModel)
                } else if selectedVal.contains(oneProductModel.address)  {
                    
                    self.productData.append(oneProductModel)
                }
            } else {
                
                self.productData.append(oneProductModel)
            }
            
        }
        self.ui_collection_prod.reloadData()
    }
    
    func filterSearchText(selectedVal : String) {
    
        self.productData.removeAll()
        for oneProductModel in allProductData{
            
            if selectedVal != "" {
            
                if oneProductModel.title.lowercased().contains(selectedVal.lowercased())  {
                    
                    self.productData.append(oneProductModel)
                }
            } else {
                
                self.productData.append(oneProductModel)
            }
            
        }
        self.ui_collection_prod.reloadData()
    }
    
    func filterCategory1(dropIndex : Int, selectedVal : String) {
        
        for oneProductModel in allProductData{
            
            if oneProductModel.category != nil {
            
                if dropIndex == 0 { // Room number
                
                    if oneProductModel.room_number == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Oda Sayısı" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 1 { // Heating
                
                    if oneProductModel.heating == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Isıtma" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 2 { // Furbished
                
                    if oneProductModel.furbished == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Eşyalı" {
                                                          
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 3 { // Price
                
                    if oneProductModel.price == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Fiyat" {
                                       
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 4 { // Room number
                
                    if oneProductModel.deposit == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Depozito" {
                    
                        self.productData.append(oneProductModel)
                    }
                }
                
            }
        }
        
        
        self.ui_collection_prod.reloadData()
    }
    
    func filterCategory2(dropIndex : Int, selectedVal : String) {
        
        for oneProductModel in allProductData{
            
            if oneProductModel.category != nil {
            
                if dropIndex == 0 { // Room number
                
                    if oneProductModel.fuel_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Yakıt" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 1 { // Heating
                
                    if oneProductModel.gear_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Vites" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 2 { // Furbished
                
                    if oneProductModel.door_number == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Kapı Sayısı" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 3 { // Price
                
                    if oneProductModel.car_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Araç Tipi" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 4 { // Room number
                
                    if oneProductModel.price == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Fiyat" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 5 { // Room number

                    if oneProductModel.deposit == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Depozito" {
                    
                        self.productData.append(oneProductModel)
                    }
                }
                
            }
        }
        
        
        self.ui_collection_prod.reloadData()
    }
    
    func filterCategory3(dropIndex : Int, selectedVal : String) {
        
        for oneProductModel in allProductData{
            
            if oneProductModel.category != nil {
            
                if dropIndex == 0 { // Room number
                
                    if oneProductModel.bed_capacity == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Yatak Kapasitesi" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 1 { // Heating
                
                    if oneProductModel.fuel_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Yakıt" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 2 { // Furbished
                
                    if oneProductModel.price == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Fiyat" {
                                                          
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 3 { // Room number
                
                    if oneProductModel.deposit == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Depozito" {
                    
                        self.productData.append(oneProductModel)
                    }
                }
                
            }
        }
        
        
        self.ui_collection_prod.reloadData()
    }
    func filterCategory4(dropIndex : Int, selectedVal : String) {
        
        for oneProductModel in allProductData{
            
            if oneProductModel.category != nil {
            
                if dropIndex == 0 { // Room number
                
                    if oneProductModel.fuel_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Yakıt" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 1 { // Heating
                
                    if oneProductModel.gear_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Vites" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 2 { // Furbished
                
                    if oneProductModel.door_number == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Kapı Sayısı" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 3 { // Price
                
                    if oneProductModel.car_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Araç Tipi" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 4 { // Room number
                
                    if oneProductModel.price == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Fiyat" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 5 { // Room number

                    if oneProductModel.deposit == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Depozito" {
                    
                        self.productData.append(oneProductModel)
                    }
                }
                
            }
        }
        
        
        self.ui_collection_prod.reloadData()
    }
    func filterCategory5(dropIndex : Int, selectedVal : String) {
        
        for oneProductModel in allProductData{
            
            if oneProductModel.category != nil {
            
                if dropIndex == 0 { // Room number
                
                    if oneProductModel.fuel_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Yakıt" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 1 { // Heating
                
                    if oneProductModel.gear_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Vites" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 2 { // Furbished
                
                    if oneProductModel.door_number == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Kapı Sayısı" {
                        
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 3 { // Price
                
                    if oneProductModel.car_type == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Araç Tipi" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 4 { // Room number
                
                    if oneProductModel.price == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Fiyat" {
                    
                        self.productData.append(oneProductModel)
                    }
                } else if dropIndex == 5 { // Room number

                    if oneProductModel.deposit == selectedVal {
                        
                        self.productData.append(oneProductModel)
                    } else if selectedVal == "Depozito" {
                    
                        self.productData.append(oneProductModel)
                    }
                }
                
            }
        }
        
        
        self.ui_collection_prod.reloadData()
    }
  
    
   
}

extension MainpageVC : UISearchBarDelegate {
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        filterSearchText(selectedVal: searchBar.text!)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //showToast("searchBarSearchButtonClickedlogin", duration: 2, position: .center)
        searchBar.endEditing(true)
        filterSearchText(selectedVal: searchBar.text!)
    }
}


extension MainpageVC: UICollectionViewDelegate {
    
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.ui_collection_cat {
            
            
            currentCatagory = indexPath.row

            for i in 0 ..< catagoryData.count {
                let state = (i == currentCatagory ? true : false)
                catagoryData[i].catagoryState = state
            }

            ui_collection_cat.reloadData()
            self.gotoProductAdsApi(catagoryId: currentCatagory + 1, pageNum: 1, isFirst: false)
        }
        else if collectionView == self.ui_collection_cat {
         
            if indexPath.row < 4 {
                  self.gotoProdauctdetailpageVC(productNum: indexPath.row)
                
            }else if indexPath.row == 4 {
            
                 self.gotoMyAdsAdd()
            
            }else if indexPath.row > 4 {
                
                  self.gotoProdauctdetailpageVC(productNum: indexPath.row-1)
            }
         } else {
            self.gotoProdauctdetailpageVC(productNum: indexPath.row)
        }
        
        collectionView.cellForItem(at: indexPath)?.pulsate()        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.ui_collection_prod {
            priOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.ui_collection_cat {
            let total = scrollView.contentSize.width - scrollView.bounds.width
            let offset = scrollView.contentOffset.x
            let percent = Double(offset / total)
            currentAdsPage = Int(percent * Double(self.adsData.count - 1))
            
        } else if scrollView == self.ui_collection_prod {
            
            
            
        }
    }
}

extension MainpageVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.ui_collection_cat {return catagoryData.count}
//        if collectionView == self.ui_collection_ads {return adsData.count}
        if collectionView == self.ui_collection_filter {return oneFilterCell.count}
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.ui_collection_cat {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageCatCell", for: indexPath) as! MainpageCatCell
            cell.entity = catagoryData[indexPath.row]
            
            return cell
        }
//        else if collectionView == self.ui_collection_ads {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageAdsCell", for: indexPath) as! MainpageAdsCell
//            if adsData.count > 0 {
//                cell.entity = adsData[indexPath.row]
//            }
//            return cell
//        }
        else if collectionView == self.ui_collection_filter {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageFilterCell", for: indexPath) as! MainpageFilterCell
            cell.entity = oneFilterCell[indexPath.row]
            cell.tag = currentCatagory
            cell.ui_dropdownFilter.tag = indexPath.row
            cell.dropDelegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageProductCell", for: indexPath) as! MainpageProductCell
        cell.entity = productData[indexPath.row]
        return cell
    }
}



extension MainpageVC : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var w : CGFloat = 0
        var h : CGFloat = 0
        
        if collectionView == self.ui_collection_cat {
            

            h = collectionView.frame.size.height
            w = h
        }
            
//        else if collectionView == self.ui_collection_ads {
//            w = collectionView.frame.size.width * 0.7
//            h = collectionView.frame.size.height * 0.9
//        }
            
        else if collectionView == self.ui_collection_filter {
            w = oneFilterCell[indexPath.row].cellWidth + 80
            h = collectionView.frame.size.height
        }
            
        else if collectionView == self.ui_collection_prod {
            
            w = (collectionView.frame.size.width - 10) / 2
            h = 220
        }
        
        return CGSize(width: w, height: h)
    }

    
   
}



    

   



extension MainpageVC : DropdownDelegate {
    
    func onSelect(categoryID: Int, dropIndex: Int, selectedVal: String) {
        
        print("categoryID: \(categoryID), dropIndex: \(dropIndex), selectedVal: \(selectedVal)")
        
        
        self.productData.removeAll()
        
        if categoryID == 1 {

            filterCategory1(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 2 {

            filterCategory2(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 3 {

            filterCategory3(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 4 {
//            self.showToast("this is 4", duration: 3, position: .center)
            filterCategory4(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 5 {

            filterCategory5(dropIndex: dropIndex, selectedVal: selectedVal)
        }
        else if categoryID == 6 {

            filterCategory5(dropIndex: dropIndex, selectedVal: selectedVal)
        }
        
        
    }
}


extension MainpageVC: SearchViewControllerDelegate {
    
    func myVCDidFinish(city: String, lat: Double, lng: Double) {
        
        filterSearchTextByCity(selectedVal: city)
    }
}


/*
extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)

        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
    
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}
*/



func buis(vc: UIViewController){
    
    let v1 = vc.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoVC") as! BusinessInfoVC
    
    vc.navigationController?.pushViewController(v1, animated: true)
    

}
