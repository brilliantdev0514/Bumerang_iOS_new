
import UIKit
import GDCheckbox
import Photos
import DKImagePickerController
import DKCamera
import SwiftyJSON
import SwiftyUserDefaults
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


//var uploadedimageArray = [UIImage]()

class AddApartmentFlatVC: BaseViewController {
    
    var  uplodimgarray:[String] = []
    @IBOutlet var collctnVW_imagesToUplosd: UICollectionView!
        
    var latitude : Double = 0
    var longitude : Double = 0
    
    var selectedPeriod = 0
    var heatingState = ""
    var furbishedState = ""
    var depositState = ""
    
    
    @IBOutlet weak var ui_titleTxt: UITextField!
    @IBOutlet weak var ui_roomNumber: UITextField!
    @IBOutlet weak var ui_heatingDropDown: DropDown!
    @IBOutlet weak var ui_furbishedDropDown: DropDown!
    @IBOutlet weak var ui_priceTxt: UITextField!
    @IBOutlet weak var ui_depositDropDown: DropDown!
    @IBOutlet weak var ui_descriptiontxtView: UITextView!
    
    @IBOutlet weak var ui_dayRadio: GDCheckbox!
    @IBOutlet weak var ui_weekRadio: GDCheckbox!
    @IBOutlet weak var ui_monthRadio: GDCheckbox!
    @IBOutlet weak var ui_uploadImg: UIImageView!
    @IBOutlet weak var ui_addrLbl: UITextField!
    
    var oneProduct : ProductModels? = nil
    
//    @IBOutlet weak var ui_uploadImgBut: UIButton!
    
    
//    @IBOutlet weak var imagecollection: UICollectionView!
    //MARK:- image picker declare
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- imageView clickable func call
        self.setClickableLabel()
        
        let heatingOption = HeatingOption()
        ui_heatingDropDown.optionArray = heatingOption.values_en
        ui_heatingDropDown.optionIds = heatingOption.ids
        ui_heatingDropDown.checkMarkEnabled = false
        ui_heatingDropDown.didSelect{(selectedText , index , id) in
            self.heatingState = selectedText
        }
        
        let boolTypeOption = BoolTypeOption()
        ui_furbishedDropDown.optionArray = boolTypeOption.values
        ui_furbishedDropDown.optionIds = boolTypeOption.ids
        ui_furbishedDropDown.checkMarkEnabled = false
//        ui_furbishedDropDown.optionImageArray = ["ic_address_grey","ic_address_grey"]
        ui_furbishedDropDown.didSelect{(selectedText , index , id) in
            self.furbishedState = selectedText
        }
        
        ui_depositDropDown.optionArray = boolTypeOption.values
        ui_depositDropDown.optionIds = boolTypeOption.ids
        ui_depositDropDown.checkMarkEnabled = false
        ui_depositDropDown.didSelect{(selectedText , index , id) in
            self.depositState = selectedText
        }
        
        if oneProduct != nil {
            
            updateView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func updateView() {
        
        ui_titleTxt.text = oneProduct?.title
        ui_roomNumber.text = oneProduct?.room_number
        heatingState = oneProduct!.heating
        ui_heatingDropDown.text = heatingState
        
        furbishedState = oneProduct!.furbished
        ui_furbishedDropDown.text = furbishedState
        
        ui_priceTxt.text = oneProduct?.price
        
        if oneProduct?.date_unit == "Gün" {
            
            selectedPeriod = 1
            ui_dayRadio.isOn = true
        } else if oneProduct?.date_unit == "Hafta" {
            
            selectedPeriod = 2
            ui_weekRadio.isOn = true
        } else if oneProduct?.date_unit == "Ay" {
            
            selectedPeriod = 3
            ui_monthRadio.isOn = true
        }
        
        depositState = oneProduct!.deposit
        ui_depositDropDown.text = depositState
        ui_descriptiontxtView.text = oneProduct?.description
        
        latitude = Double(oneProduct!.lat)!
        longitude = Double(oneProduct!.lng)!
        ui_addrLbl.text = oneProduct?.address
        
        if oneProduct!.image_url.starts(with: "http") {

            let str = oneProduct!.image_url.components(separatedBy: ",")
            ui_uploadImg.sd_setImage(with: URL(string: str[0]))
            
        }
    }
    
    @IBAction func onCheckBoxPress(_ sender: GDCheckbox) {
        getPeriodVal(sender.tag)
    }
    
    @IBAction func onClickDaily(_ sender: Any) {
        ui_dayRadio.isOn = true
        getPeriodVal(1)
    }
    
    @IBAction func onClickWeek(_ sender: Any) {
        ui_weekRadio.isOn = true
        getPeriodVal(2)
    }
    
    @IBAction func onClickMonth(_ sender: Any) {
        ui_monthRadio.isOn = true
        getPeriodVal(3)
    }
    
    func getPeriodVal(_ val : Int) {
        
        selectedPeriod = val
        
        if val == 1 {
            ui_weekRadio.isOn = false
            ui_monthRadio.isOn = false
        } else if val == 2 {
            ui_dayRadio.isOn = false
            ui_monthRadio.isOn = false
        } else if val == 3 {
            
            ui_dayRadio.isOn = false
            ui_weekRadio.isOn = false
        }
        
    }

   //MARK:- image select func
    func selectImage(){
        
        let galleryAction = UIAlertAction(title: "galeriden", style: .destructive) { (action) in
            self.openGallary()
        }
        let cameraAction = UIAlertAction(title: "kameradan", style: .destructive) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title:R_EN.string.CANCEL, style: .cancel, handler : nil)
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: R_EN.string.APP_TITLE, message: R_EN.string.CORNFRIM_IMAGE_SETMODE, preferredStyle: .alert)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK:- image choose from camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Uyarı", message: "Kameran yok", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R_EN.string.OK, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
     //MARK:- image choose from gallary
     func openGallary(){
         imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
         //If you dont want to edit the photo then you can set allowsEditing to false
         imagePicker.allowsEditing = true
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
     }
    //MARK:- imageView clickable func
    func setClickableLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddApartmentFlatVC.tapFunction))
        
        ui_uploadImg.isUserInteractionEnabled = true
        ui_uploadImg.addGestureRecognizer(tap)
    }
    //MARK:- select image func call
    @objc func tapFunction(sender:UITapGestureRecognizer) {

           selectImage()
            
        }
    
    
//    func openGallery() {
//        let pickerController = DKImagePickerController()
//        pickerController.assetType = .allAssets
//        pickerController.allowSwipeToSelect = true
//        pickerController.sourceType = .photo
//        pickerController.singleSelect = true
//        pickerController.dismissCamera()
//        pickerController.showsCancelButton = true
//        pickerController.didSelectAssets = {(assets: [DKAsset]) in
//            self.onSelectAssets(assets: assets)
//        }
//
//        present(pickerController, animated: true, completion : nil)
//    }
//
//    func openCamera(){
//
//        let camera = DKCamera()
//        camera.allowsRotate = true
//        camera.showsCameraControls = true
//        camera.defaultCaptureDevice = DKCameraDeviceSourceType.rear
//
//        camera.didCancel = {self.dismiss(animated: true, completion: nil)}
//        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
//            self.dismiss(animated: true, completion: nil)
//
//            if let img = image {
//                self.ui_uploadImg.image = img
//                self.ui_uploadImgBut.setTitle("", for: .normal)
//            }
//        }
//
//        present(camera, animated: true, completion: nil)
//    }
//
//    func onSelectAssets(assets : [DKAsset]) {
//        if assets.count > 0 {
//            for asset in assets {
//                asset.fetchOriginalImage(options: nil, completeBlock: { image, info in
//                    if let img = image {
//
//                        uploadedimageArray.append(img)
//
////                        self.ui_uploadImgBut.setTitle("Upload More", for: .normal)
//
////                        self.imagecollection.reloadData()
//                    }
//                })
//            }
//        }
//        else {}
//    }
    //MARK:- didClickupload button
    @IBAction func onClickLocationButton(_ sender: Any) {
        
        let toSearch = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        toSearch.delegate = self
        self.modalPresentationStyle = .fullScreen
        self.present(toSearch, animated: true, completion: nil)
    }
    
    @IBAction func onClickUpload(_ sender: Any) {
        
        var showStr = ""
        
        let titleTxt = ui_titleTxt.text!
        let roomNumTxt = ui_roomNumber.text!
        let priceTxt = ui_priceTxt.text!
        let desciptTxt = ui_descriptiontxtView.text!
        let addr = ui_addrLbl.text!
        let lat = String(latitude)
        let lng = String(longitude)
        let zipCode = "123456"
        
        if titleTxt.isEmpty {
            showStr = R_EN.string.ENTER_PRODUCT_TITLE
        }
        else if roomNumTxt.isEmpty {
            showStr = R_EN.string.ENTER_ROOM_NUMBER
        }
        else if heatingState.isEmpty {
            showStr = R_EN.string.SELECT_HOUSE_HEATING
        }
        else if furbishedState.isEmpty {
            showStr = R_EN.string.SELECT_HOUSE_FURBISHED
        }
        else if selectedPeriod == 0 {
            showStr = R_EN.string.ENTER_PRODUCT_PRICETYPE
        }
        else if priceTxt.isEmpty {
            showStr = R_EN.string.ENTER_PRODUCT_PRICE
        }
        else if depositState.isEmpty {
            showStr = R_EN.string.SELECT_DEPOSIT
        }
        else if addr.isEmpty {
            showStr = R_EN.string.SELECT_ADDR
        }
            
//        else if uploadedimageArray.count == 0 {
//            showStr = R_EN.string.SELECT_PRODUCT_IMAGE
//        }
        
        if showStr.isEmpty {
            
            var imageStrings: String!
            
            
            //MARK: file manager operating
//                let fileManager = FileManager.default
//                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//                let documentDirectory = paths[0]
//
//                // current document directory
//                fileManager.changeCurrentDirectoryPath(documentDirectory as String)
//
//                do {
//                    try fileManager.createDirectory(atPath: Constants.SAVE_ROOT_PATH, withIntermediateDirectories: true, attributes: nil)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//
//                let savedFilePath = "\(documentDirectory)/\(Constants.SAVE_ROOT_PATH)/upload.png"
//
//                // if the file exists already, delete and write, else if create filePath
//                if (fileManager.fileExists(atPath: savedFilePath)) {
//                    do {
//                        try fileManager.removeItem(atPath: savedFilePath)
//                    }
//                    catch let error as NSError {
//                        print("Ooops! Something went wrong: \(error)")
//                    }
//                } else {
//                    fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
//                }
            
            
           
//                if let data = resize(image: uploadedimageArray[i], maxHeight: 512, maxWidth: 512, compressionQuality: 1, mode: "PNG") {
//
//                    do {
//                        try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
//                    } catch {
//                        print(error)
//                    }
//                }
                
          
                 
                
            self.showALLoadingViewWithTitle(title: "İlanlar yükleniyor ", type: .messageWithIndicator )
            
            //MARK:- upload image
            uploadMedia() { url in
                 guard let url = url else {
                    
                    self.hideALLoadingView()
                    return }
                imageStrings = url
                //self.gotoUploadApi(title: titleTxt, roomnum: roomNumTxt, heating: self.heatingState, furbished: self.furbishedState, priceType: priceOption[self.selectedPeriod], price: priceTxt, deposit: self.depositState, description: desciptTxt, image: imageStrings, addr: addr, lat: lat, lng: lng, zipCode: zipCode)
                
                if self.oneProduct != nil {
                    
                    self.gotoUpdateApi(title: titleTxt, roomnum: roomNumTxt, heating: self.heatingState, furbished: self.furbishedState, priceType: priceOption[self.selectedPeriod], price: priceTxt, deposit: self.depositState, description: desciptTxt, image: self.uplodimgarray, addr: addr, lat: lat, lng: lng, zipCode: zipCode)
                } else {
                    self.gotoUploadApi(title: titleTxt, roomnum: roomNumTxt, heating: self.heatingState, furbished: self.furbishedState, priceType: priceOption[self.selectedPeriod], price: priceTxt, deposit: self.depositState, description: desciptTxt, image: self.uplodimgarray, addr: addr, lat: lat, lng: lng, zipCode: zipCode)
                }
            }
            
            
        
        } else {
            showToast("Yükleme başarısız!", duration: 1, position: .top)
            return
        }
            
    }
    
    //MARK:- gotoUpload
    func gotoUploadApi(title: String, roomnum : String, heating: String, furbished:String, priceType: String, price : String, deposit: String, description : String, image:  Array<Any>, addr : String, lat : String, lng : String, zipCode: String) {
    
//        self.showHUD()
        
        
        
        let ownerid = Auth.auth().currentUser!.uid
        let productId = UUID().uuidString
        
        let productDict: [String: Any] = [ProductData.title: title, ProductData.room_number: roomnum, ProductData.heating: heating, ProductData.furbished: furbished, ProductData.date_unit: priceType, ProductData.price: price, ProductData.deposit: deposit, ProductData.description: description, ProductData.address: addr, ProductData.lat: lat, ProductData.lng: lng, ProductData.zip_code: zipCode, ProductData.owner_id: ownerid, ProductData.image_url: uplodimgarray, ProductData.bed_capacity: "", ProductData.captan: "", ProductData.car_type: "", ProductData.category: "1", ProductData.color: "", ProductData.created_at: "", ProductData.door_number: "", ProductData.fuel_type: "", ProductData.gear_type: "", ProductData.gender: "", ProductData.membershipState: ShareData.user_info.membership!, ProductData.person_capacity: "", ProductData.rental_status: "", ProductData.score: "", ProductData.size: "", ProductData.updated_at: "", ProductData.product_id: productId]
        
        ProductData.dbProRef.child(productId).setValue(productDict)
        //ProductData.product_info = ProductModels.init(dictPro: productDict)
        
        self.hideALLoadingView()
        
        //self.showToast("Success!", duration: 2, position: .top)
        
        self.gotoAddProductSucessVC ()
        print("Product id is \(productId)")
        
    }
    
    func gotoUpdateApi(title: String, roomnum : String, heating: String, furbished:String, priceType: String, price : String, deposit: String, description : String, image:  Array<Any>, addr : String, lat : String, lng : String, zipCode: String) {
        
    //        self.showHUD()
            
            let ownerid = Auth.auth().currentUser!.uid
            
            let productDict: [String: Any] = [ProductData.title: title, ProductData.room_number: roomnum, ProductData.heating: heating, ProductData.furbished: furbished, ProductData.date_unit: priceType, ProductData.price: price, ProductData.deposit: deposit, ProductData.description: description, ProductData.address: addr, ProductData.lat: lat, ProductData.lng: lng, ProductData.zip_code: zipCode, ProductData.owner_id: ownerid, ProductData.image_url: uplodimgarray, ProductData.bed_capacity: "", ProductData.captan: "", ProductData.car_type: "", ProductData.category: "1", ProductData.color: "", ProductData.created_at: "", ProductData.door_number: "", ProductData.fuel_type: "", ProductData.gear_type: "", ProductData.gender: "", ProductData.membershipState: "", ProductData.person_capacity: "", ProductData.rental_status: "", ProductData.score: "", ProductData.size: "", ProductData.updated_at: ""]
            
            //ProductData.dbProRef.child(productId).setValue(productDict)
            //ProductData.product_info = ProductModels.init(dictPro: productDict)
            
            ProductData.dbProRef.child(oneProduct!.product_id).updateChildValues(productDict)
            self.hideALLoadingView()
            
            //self.showToast("Success!", duration: 2, position: .top)
            
            self.gotoAddProductSucessVC ()            
        }
    
    
    func setFormData() {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    
        
//        ui_titleTxt.text = ""
//        ui_priceTxt.text = ""
//        ui_descriptiontxtView.text = ""
//        ui_addrLbl.text = ""
//        ui_uploadImg.image = nil
//        ui_uploadImgBut.setTitle(R_EN.string.SELECT_UPLOAD_IMAGAE, for: .normal)
//        ui_dayRadio.isOn = false
//        ui_weekRadio.isOn = false
//        ui_monthRadio.isOn = false
//        ui_depositDropDown.select(0)
//        selectedPeriod = 0
//
//        ui_roomNumber.text = ""
//        ui_heatingDropDown.select(0)
//        ui_furbishedDropDown.select(0)
    }
    
    //MARK:- image uploading
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("images").child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //ui_uploadImg.image error
        guard let imageData = self.ui_uploadImg.image!.jpegData(compressionQuality: 0.75) else { return }
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
          
          if error == nil, metaData != nil {

            storageRef.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {
                    self.uplodimgarray.append(urlText)
                    print("imageArray",self.uplodimgarray)

                    completion(urlText)

                }
            })
            
          } else {
              // failed
              completion(nil)
          }
         
        }
    }
        
        @IBAction func imageUploadBtn(_ sender: UIButton) {
//            let intTag = sender.tag
//            if sender.currentImage!.isEqual(UIImage(named: "add"))
//            {
                
                selectImage()
//            }
//            else{
    //        guard let indexPath = self.collctnVW_imagesToUplosd.indexPathsForVisibleItems.first.flatMap({
    //            IndexPath(item: (intTag-10) , section: $0.section)
    //        }), self.collctnVW_imagesToUplosd.cellForItem(at: indexPath) != nil else {
    //            return
    //        }
    //            let indx = IndexPath.init(row: intTag-10, section: 0)
    //           // self.collctnVW_imagesToUplosd.selectItem(at: indx, animated: true, scrollPosition: [])
    //          //  self.collctnVW_imagesToUplosd.scrollToItem(at: indx, at: .centeredHorizontally, animated: false)
    //
    //            let visibleItems: NSArray = self.collctnVW_imagesToUplosd.indexPathsForVisibleItems as NSArray
    //
    //            var minItem: NSIndexPath = visibleItems.object(at: intTag-10) as! NSIndexPath
    //            for itr in visibleItems {
    //
    //                if minItem.row > (itr as AnyObject).row {
    //                    minItem = itr as! NSIndexPath
    //                }
    //            }
    //
    //            let nextItem = NSIndexPath(row: minItem.row + 1, section: 0)
    //            self.collctnVW_imagesToUplosd.scrollToItem(at: indx, at: .centeredHorizontally, animated: true)
    //

                //self.collctnVW_imagesToUplosd.scrol
//            }
        }
}


//MARK:-UIImagePickerControllerDelegate
extension AddApartmentFlatVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let selectedImage = info[.editedImage] as? UIImage {
                    self.ui_uploadImg.image = selectedImage
                    self.showALLoadingViewWithTitle(title: "İlanlar yükleniyor ", type: .messageWithIndicator )
                    let imageName = NSUUID().uuidString
                                         let storageRef = Storage.storage().reference().child("images").child(imageName)
                                        
                                         let metaData = StorageMetadata()
                                         metaData.contentType = "image/jpg"
                                         
                                         //ui_uploadImg.image error
                                         guard let imageData = self.ui_uploadImg.image!.jpegData(compressionQuality: 0.75) else { return }
                                         storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                                           
                                           if error == nil, metaData != nil {

                                             storageRef.downloadURL(completion: { (url, error) in
                                                 if let urlText = url?.absoluteString {
                                                     print("imageaagai",urlText)
                                                    self.hideALLoadingView()
                                                    self.uplodimgarray.append(urlText)
                                                   DispatchQueue.main.async {
                                                        self.collctnVW_imagesToUplosd.reloadData()
                                                    let tmpButton:UIButton = (self.view.viewWithTag(10+self.uplodimgarray.count) as? UIButton)!
                                                    let string = self.uplodimgarray[self.uplodimgarray.count-1]
                                                     let url = URL(string: string)
                                                     let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise
                                                    tmpButton.setImage(UIImage.init(data: data!), for: .normal)
                                                    }
                                                    //print("imageArray",self.uplodimgarray)
                                                 }

                                             })
                                           } else {
                                               // failed
                                             //  completion(nil)
                                           }
                                         
                                         }
                             
                                    // }
                           //   self.present(imagePicker, animated: true, completion: nil)
                    
                   picker.dismiss(animated: true, completion: nil)
                    
                }
            }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddApartmentFlatVC: SearchViewControllerDelegate {
    
    func myVCDidFinish(city: String, lat: Double, lng: Double) {
        
        ui_addrLbl.text = city;
        latitude = lat
        longitude = lng
    }
}
extension AddApartmentFlatVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collctnVW_imagesToUplosd)
        {
            if(oneProduct != nil){
               return oneProduct!.image_urls.count
//            if oneProduct!.image_url.starts(with: "http") {
//
//
//                              let str = oneProduct!.image_url.components(separatedBy: ",")
//                              print(str)
//
//                       return str.count
//
//
//
//                    }
            }
            else
            {
           return self.uplodimgarray.count
            }
            return 0;
        }
        else
        {
             return 6
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collctnVW_imagesToUplosd)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
            
           if oneProduct == nil {
           // let url = URL(string: self.uplodimgarray[indexPath.row])
            let string = self.uplodimgarray[indexPath.row]
            let url = URL(string: string)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //imageView.image = UIImage(data: data!)
           // cell.image.image = UIImage(data: data!)
            cell.imageVWItem.sd_setImage(with: url, completed: nil)
            }
           else if(oneProduct!.image_urls.count > 0 ){
            cell.imageVWItem.sd_setImage(with: URL.init(string: oneProduct!.image_urls![indexPath.row] as! String), completed: nil)
//            if oneProduct?.image_url.starts(with: "http") ?? false {
//
//
//                let str = oneProduct!.image_url.components(separatedBy: ",")
//                if indexPath.row == 0{
//
//                    cell.image.sd_setImage(with: URL(string: str[0]))
//
//
//
//                }else{
//
//                    let index = str[0].index(str[0].startIndex, offsetBy: 26)
//
//                    let baseurl = String(str[0].prefix(upTo: index))
//
//                    print(baseurl)
//
//                        cell.image.sd_setImage(with: URL(string: baseurl + str[indexPath.row]))
//
//
//
//                }
 
                 }
                 else {
                     
                  cell.imageVWItem.image = UIImage(named: oneProduct!.placeHolerImage)
                     
                 }

            return cell
        }
        else
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addcarcell", for: indexPath) as! addcarcell
        
        
        
        
             return cell
        }
        
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

           collectionView.performBatchUpdates(nil, completion: nil)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:  self.view.frame.size.height)
//        self.collctnVW_imagesToUplosd.item:CGSize(view.frame.width, self.view.frame.size.height)];
//
//           switch collectionView.indexPathsForSelectedItems?.first {
//           case .some(indexPath):
//               let height = (view.frame.width) * 3/4
//               return CGSize(width: view.frame.width, height: height + 50 + 150)
//           default:
//               let height = (view.frame.width) * 9 / 16
//               return CGSize(width: view.frame.width, height: height + 50 + 50)
//           }
       }
       
    
    
}



