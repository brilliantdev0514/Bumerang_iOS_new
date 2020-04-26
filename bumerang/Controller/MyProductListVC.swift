//
//  MyProductListVC.swift
//  bumerang
//
//  Created by RMS on 10/25/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

/// 状态栏高度
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
/// 导航栏高度
let kNavBarHeight: CGFloat = 44.0

class MyProductListVC: BaseViewController {

    @IBOutlet weak var ui_conlectionProduct: UICollectionView!
    @IBOutlet weak var ui_viewEmptyProduct: UIView!
    
    var productData = [ProductModels]()
    var productDataFilters = [ProductModels]()
    
    let titles = [
        "All", Constants.categoryName[0],
        Constants.categoryName[1], Constants.categoryName[2],
        Constants.categoryName[3], Constants.categoryName[4]
    ]
        
    lazy var menuView2: FWMenuView = {
        
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topRight
        vProperty.popupAnimationType = .scale
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.2)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: kStatusBarHeight + kNavBarHeight, left: 0, bottom: 0, right: 8)
        vProperty.topBottomMargin = 10
        vProperty.animationDuration = 0.3
        vProperty.popupArrowStyle = .round
        vProperty.popupArrowVertexScaleX = 1
        vProperty.backgroundColor = UIColor.white
        vProperty.splitColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.separatorColor = kPV_RGBA(r: 91, g: 91, b: 93, a: 1)
        vProperty.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        vProperty.textAlignment = .left
        vProperty.separatorInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: nil, itemBlock: { (popupView, index, title) in
            self.setFilterData(index, title: title!)
        }, property: vProperty)
//                menuView.attachedView = self.view
        
        return menuView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuButton()
        
        getMyProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupMenuButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"ic_filter"), for: .normal)
        menuBtn.addTarget(self, action: #selector(rightbuttonPressed), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    func setFilterData (_ categoryId : Int, title: String) {
        
        self.showALLoadingViewWithTitle(title: "Waiting", type: .messageWithIndicator, mode: .windowed)
        productDataFilters.removeAll()
        
        if categoryId > 0 {
            for one in productData {
                if one.category == "\(categoryId)" { productDataFilters.append(one) }
            }
        } else {
            productDataFilters = productData
        }
        ui_conlectionProduct.reloadData()
        ui_conlectionProduct.layoutIfNeeded()
        
        self.hideALLoadingView()
    }
    
    func setEmptyProductViewVisablity(_ isSucess: Bool, state: String ) {
        
        if isSucess == true {
            
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
    }
    
    @objc func rightbuttonPressed() {
        self.menuView2.show()
    }
    
    func getMyProductList() {
        
        var img = "http://178.157.15.79:3001/uploads/product/product-1571065818565.png"
        var state = "Evet"
        for i in 0 ..< 12 {
            
            if i % 2 == 1 {
                state = "Hayır"
                img = "http://178.157.15.79:3001/uploads/product/product-1571471670140.jpg"
            } else {
                img = "http://178.157.15.79:3001/uploads/product/product-1571065818565.png"
                state = "Evet"
            }
            let catID = i % 5 + 1
            let one = ProductModels(categoryId: "\(catID)", productId: "\(i)", productImg:"", title: "qwerqwer", priceVal: "12.3", priceType: "Ay", rentalStatus: state, updated_at: ShareData.formattedDateString(), created_at: ShareData.formattedDateString())

            productData.append(one)
        }
        
        productDataFilters = productData
    }
    
    func gotoADSAddVC(_ index : Int) {
        
//        if productDataFilters[index].adsState == "Yes" {
//            let str = "Becuse this product is already adviertised in app, you cannot advertise to that."
//            showToast(str, duration: 3, position: .center)
//            return
//        }
//        
//        let categoryName = Constants.categoryName[productDataFilters[index].categoryId]
//        let productName = productDataFilters[index].title
//        
//        var msg = "Do you advetise the product \"" + productName.trimmed
//        msg += " of category \"" + categoryName.trimmed + "\" to this app?"
//        
//        
//        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: R_EN.string.CANCEL, style: .default, handler: nil))
//        
//        alert.addAction(UIAlertAction(title: R_EN.string.OK, style: .default, handler : {(action) -> Void in
//            
//            let toVC = self.storyboard?.instantiateViewController( withIdentifier: "PaymentPage1VC") as! PaymentPage1VC
//            toVC.adsCost = self.productDataFilters[index].adsCost
//            toVC.modalPresentationStyle = .fullScreen
//            
//            self.navigationController?.pushViewController(toVC, animated: true)
//            
//        }))
//        
//        DispatchQueue.main.async(execute:  {
//            self.present(alert, animated: true, completion: nil)
//        })
        
    }
}


extension MyProductListVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductCell", for: indexPath) as! MyProductCell
        cell.entity = productDataFilters[indexPath.row]

        
        
        
        return cell
    }
}

extension MyProductListVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.gotoADSAddVC(indexPath.row)
    }
}

extension MyProductListVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        
        return CGSize(width: w, height: 110)
    }
}
