//
//  favourite.swift
//  bumerang
//
//  Created by mac on 02/12/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class favourite: BaseViewController {

 
        
        
        @IBOutlet weak var ui_productLbl: UILabel!
        
        var productData = [ProductModels]()
           var reviewData = [UserReviewModel]()

        
        
        @IBOutlet weak var ui_product_coll: UICollectionView!
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadProductData()

            
        }
        
        
        func loadProductData(){
              for i in 0 ..< 11 {
                  let medal = (i % 2 == 0 ? false: true)
                  let top1 = (i % 3 == 0 ? "top1": "")
                  let top2 = (i % 3 == 1 ? "temp1": "temp1")
                  let mid = (i % 2 == 0 ? "midTemp1": "midTemp2")
                  let bottom : Float = i % 2 == 0 ? 50 : 100
                  let dateType = "day"
                  
                let one = ProductModels(category: "1", productId: "\(i)", productImg: "", title: "", rentState: "0", lblTop1: top1, lblTop2: top2, lblMid: mid, price: "\(bottom)",dateType: dateType)
                  
                  productData.append(one)
              }
              
          
              
              ui_product_coll.reloadData()
              ui_product_coll.layoutIfNeeded()
          }
          
          func loadReviewData(){
              for i in 0 ..< 14 {
                  
                  let one = UserReviewModel(reviewId: i, avatarImg: "ic_avatar", producTitle: "Product Title", reveiwVal: Float(i % 5), reviewStr: "Great customer, he had always kept promise", userName: "JaingYin Ji", reviewDate: "10/21/2019")
                  
                  reviewData.append(one)
              }
          
          
          }
        
        
        
        
        
        
              
          func setupMenuButton() {
        
             
              let menuRightBtn = UIButton(type: .custom)
              menuRightBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
              menuRightBtn.setImage(UIImage(named:"ic_setting"), for: .normal)
            
              
              let menuBarItem = UIBarButtonItem(customView: menuRightBtn)
              let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
              currWidth?.isActive = true
              let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
              currHeight?.isActive = true
              self.navigationItem.rightBarButtonItem = menuBarItem
          }
        
        
        
        @IBAction func leftbuttonPressed() {
            self.navigationController?.popViewController(animated: true)
         }
        

       

    }



    extension favourite: UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if collectionView == self.ui_product_coll {
                
                
                
                
            }

        }
        
    }

    extension favourite : UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             
            return productData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserinfoProductCell", for: indexPath) as! UserinfoProductCell
                cell.entity = productData[indexPath.row]
                
                return cell
         
         
        }
        
    }

    extension favourite : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            var w : CGFloat = 0
            var h : CGFloat = 0
            if collectionView == self.ui_product_coll {
                w = (collectionView.frame.size.width - 10) / 2
                h = collectionView.frame.size.height / 2 - 5
            }
            
           
            
            return CGSize(width: w, height: h)
        }
    }

