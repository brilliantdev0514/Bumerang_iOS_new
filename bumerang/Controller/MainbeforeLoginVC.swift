//
//  MainbeforeLoginVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/5.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import UPCarouselFlowLayout
import FanMenu
import Macaw
import FirebaseAuth
import FirebaseDatabase

class MainbeforeLoginVC: BaseViewController {
    var selectedindex = 0
    
    @IBOutlet weak var ui_searchBar: UISearchBar!
    @IBOutlet weak var ui_collection_cat: UICollectionView!
    @IBOutlet weak var ui_collection_prod: UICollectionView!
    @IBOutlet weak var ui_collection_filter: UICollectionView!
    @IBOutlet weak var ui_view_coll_filter: UIView!
    @IBOutlet weak var ui_butSign: UIButton!
    
    @IBOutlet weak var ui_viewEmptyProduct: UIView!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gotoProductAdsApi(catagoryId: 0, pageNum: 1, isFirst: true )
        loadCatagoryData()
        setFilterAllData()
        ui_butSign.setTitle("Giriş Yap", for: .normal)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    @IBAction func firstBtnClick(_ sender: Any) {

        let toSigninVC = storyboard?.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        self.modalPresentationStyle = .fullScreen
        self.present(toSigninVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ui_collection_cat.reloadData()
        ui_collection_cat.layoutIfNeeded()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func setupLayout() {
        
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 15)
        layout.sideItemScale = 0.9
        layout.sideItemAlpha = 1
        
        
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
        
        for index in 0 ..< 11 {
            
            switch index {
               case 1:
                   
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
                   
               case 2:
                   
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
               case 3:
                   
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
    
    @IBAction func onClickLocation(_ sender: Any) {
        showToast("ClickLocationButton", duration: 2, position: .center)
    }
    
    func loadCatagoryData(){
        for i in 0 ..< Constants.cateImage.count {
            
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
    
    func loadFilterData(_ catagoryID: Int) {
        
        oneFilterCell.removeAll()
        oneFilterCell = allFilterData[catagoryID]
        print("======================")
        print(catagoryID)
        setVisablity(category: 0)
        ui_collection_filter.reloadData()
        ui_collection_filter.layoutIfNeeded()
    }
    
   
    func setVisablity(category: Int) {
        
        if oneFilterCell.count == 0 {
            
            self.ui_collection_filter.visiblity(gone: true, dimension: 0.0)
            self.ui_view_coll_filter.visiblity(gone: true, dimension: 0.0)
            
        } else {
            
            self.ui_collection_filter.visiblity(gone: false, dimension: 50)
            self.ui_view_coll_filter.visiblity(gone: false, dimension: 55)
        }
    }
    
    func setEmptyProductViewVisablity(_ isSucess: Bool, state: String ) {
        
        if isSucess == true {
            if state == "0" {
                ui_viewEmptyProduct.isHidden = false
            }
            else {
                ui_viewEmptyProduct.isHidden = true
            }
        } else {
            if state == "" {
                self.showToast(R_EN.string.CONNECT_FAIL)
            }
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
    //MARK:- gotoProduct
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
                    case 1:
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
                                        print(catagoryNum)
                                        if isFirst {
                                            self.productData.append(oneProductModel!)
                                            self.allProductData.append(oneProductModel!)
                                        }
                                        else if catagoryId != 0 && catagoryId == catagoryNum {
                                            self.productData.append(oneProductModel!)
                                            self.allProductData.append(oneProductModel!)
                                        }
//                                        else if catagoryId == catagoryNum {
//                                            self.productData.append(oneProductModel!)
//                                            self.allProductData.append(oneProductModel!)
//                                        }
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
    
    func gotoProdauctdetailpageVC( productID : Int) {
        
        var nameVC = ""
        let catagoryNum = Int(productData[productID].category)
        
        switch  catagoryNum {
        case 1 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
            toVC.oneProduct = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)
            
        case 2 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
            toVC.oneProduct = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)

        case 3:
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CaravanDetailVC") as! CaravanDetailVC
            toVC.oneProduct = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)

        case 4 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "SeaVehicleDetailVC") as! SeaVehicleDetailVC
            toVC.oneProduct = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)

        case 5 :

            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ClothDetailVC") as! ClothDetailVC
            toVC.oneProduct = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)
        case 6:

            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "BikeDetailVC") as! BikeDetailVC
            toVC.oneProduct_ = productData[productID]
            self.navigationController?.pushViewController(toVC, animated: true)

        case 7 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
            toVC.oneProduct = productData[productID]
            toVC.navigationTitle = "Camera Detail"
            self.navigationController?.pushViewController(toVC, animated: true)

       

        case 8:
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
            toVC.oneProduct = productData[productID]
            toVC.navigationTitle = "Kamp Detail"
            self.navigationController?.pushViewController(toVC, animated: true)

        case 9 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
            toVC.oneProduct = productData[productID]
            toVC.navigationTitle = "Music Detail"
            self.navigationController?.pushViewController(toVC, animated: true)

        case 10 :
            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraDetailVC") as! CameraDetailVC
            toVC.oneProduct = productData[productID]
            toVC.navigationTitle = "Other Detail"
            self.navigationController?.pushViewController(toVC, animated: true)
            
        default:
            nameVC = ""
        }
        
        if nameVC.isEmpty {
            return
        }
        
        showToast(nameVC, duration: 1, position: .center)
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
            
                if dropIndex == 0 { // Fuel Type
                
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
}

extension MainbeforeLoginVC : UISearchBarDelegate {
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        
        filterSearchText(selectedVal: searchBar.text!)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //showToast("searchBarSearchButtonClicked", duration: 2, position: .center)
        searchBar.endEditing(true)
        filterSearchText(selectedVal: searchBar.text!)
    }
}

extension MainbeforeLoginVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.ui_collection_cat {

            currentCatagory = indexPath.row

            for i in 0 ..< catagoryData.count {
                let state = (i == currentCatagory ? true : false)
                catagoryData[i].catagoryState = state
            }

            ui_collection_cat.reloadData()

            self.gotoProductAdsApi(catagoryId: currentCatagory + 1, pageNum: 1 , isFirst: false )

        } else {

//            self.gotoProdauctdetailpageVC(productID: indexPath.row)
            self.showToast("Lütfen giriş yapın !", duration: 3, position: .center)
        }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.ui_collection_prod {
            priOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension MainbeforeLoginVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.ui_collection_cat {return catagoryData.count}
        if collectionView == self.ui_collection_filter {return oneFilterCell.count}
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.ui_collection_cat {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainpageCatCell", for: indexPath) as! MainpageCatCell
            cell.entity = catagoryData[indexPath.row]
            
            return cell
        }
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
        print(cell.entity)
        return cell
    }
}

extension MainbeforeLoginVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var w : CGFloat = 0
        var h : CGFloat = 0
        
        if collectionView == self.ui_collection_cat {
            h = collectionView.frame.size.height
            //w = h * 1.2
            w = h
            
            print("Height.. \(h) ...... Width \(w)")
            
        }
            
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

extension MainbeforeLoginVC : DropdownDelegate {
    
    func onSelect(categoryID: Int, dropIndex: Int, selectedVal: String) {
        
        print("categoryID: \(categoryID), dropIndex: \(dropIndex), selectedVal: \(selectedVal)")
                
        self.productData.removeAll()
        
        if categoryID == 1 {

            filterCategory1(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 2 {

            filterCategory2(dropIndex: dropIndex, selectedVal: selectedVal)
        } else if categoryID == 3 {

            filterCategory3(dropIndex: dropIndex, selectedVal: selectedVal)
        }
        else if categoryID == 4 {

            filterCategory3(dropIndex: dropIndex, selectedVal: selectedVal)
        }
        else if categoryID == 5 {

            filterCategory3(dropIndex: dropIndex, selectedVal: selectedVal)
        }
    }
}
