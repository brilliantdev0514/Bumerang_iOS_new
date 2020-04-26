//
//  SelectMemberShipVC.swift
//  bumerang
//
//  Created by RMS on 2019/10/8.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import CHIPageControl
import UPCarouselFlowLayout

class membership : BaseViewController {
    
    // selected Membership andcategory
    var currentPage = 0
    let myMerbership = 0
    
    internal let numberOfPages = 3
    private var progress = 0.0
    
    @IBOutlet var pageControls: [CHIBasePageControl]!
    @IBOutlet weak var ui_collection: UICollectionView!
    @IBOutlet weak var ui_butUpgrade: dropShadowDarkButton!
    @IBOutlet weak var ui_butBack: UIView!
    @IBOutlet weak var ui_butClose: UIButton!
    
    @IBOutlet weak var ui_viewStart: UIView!
    @IBOutlet weak var ui_viewPlus: UIView!
    @IBOutlet weak var ui_viewPrime: UIView!
    
    
    var datasource = [IntroModel]()
    
//    let imgNames = ["ic_medal_copper", "ic_medal_sliver", "ic_medal.gold"]
    let imgNames = ["member_START","member_PLUS","member_PRIME"]
    let topicStr = ["Start Membership", "Plus Membership", "Prime Membership"]
    let contentStr = [
        "Start member can upload 20 products in this app and advertise one of them",
        "Plus member can upload 100 products in this app and advertise one of them",
        "Prime Member can upload 300 products in this app and advertise one of them"
    ]
    
    var pageSize: CGSize {
        let layout = ui_collection.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< imgNames.count {
            let one = IntroModel(imgName: imgNames[i], topicStr: topicStr[i], contentStr: contentStr[i])
            datasource.append(one)
        }
        
        ui_collection.scrollToItem(at: IndexPath.init(row: Int(currentPage), section: 0) , at: .centeredHorizontally, animated: true)
        
        self.setupLayout()
        self.updateButtonSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.pageControls.forEach { (control) in
            control.numberOfPages = self.numberOfPages
            control.progress = Double(currentPage)
        }
        setStateViewBackground()
    }
    
    func setupLayout() {
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: self.ui_collection.frame.width - 80, height: self.ui_collection.bounds.height)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 10)
        layout.sideItemScale = 0.9
        layout.sideItemAlpha = 0.9
        
        ui_collection.collectionViewLayout = layout
    }
    
    @IBAction func onTapedClose(_ sender: Any) {
        self.gotoMainBeforeVC()
    }
    
    @IBAction func onTapedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapedUpgrade(_ sender: Any) {
        
        if selectedCategoryID >= 0 {
            
            selectedMembership = self.currentPage
            selectedUserType = 1
            
            let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SignupVC") as! SignupVC
            toVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(toVC, animated: true)
            
        } else {
            showToast("onTapedUpgrade")
        }
    }
    
    func setStateViewBackground() {
        ui_viewStart.backgroundColor = UIColor(named: "cate_back")
        ui_viewPlus.backgroundColor = UIColor(named: "cate_back")
        ui_viewPrime.backgroundColor = UIColor(named: "cate_back")
        if currentPage == 0 {
            ui_viewStart.backgroundColor = UIColor(named: "grayColor")
        } else if currentPage == 1 {
            ui_viewPlus.backgroundColor = UIColor(named: "grayColor")
        } else if currentPage == 2 {
            ui_viewPrime.backgroundColor = UIColor(named: "grayColor")
        }
    }
    
    
    func updateButtonSetting() {
        setStateViewBackground()
        var eventState = true
        var butName = "SELECT"
        
        if selectedCategoryID > -1 {
            butName = "SELECT"
            ui_butBack.isHidden = true
            ui_butClose.isHidden = false
        } else {
            ui_butBack.isHidden = false
            ui_butClose.isHidden = true
            
            if currentPage == myMerbership {
                butName = "CURRENT PLAN"
                eventState = false
            } else {
                butName = "UPGRADE"
            }
            
            if eventState {
                ui_butUpgrade.borderWidth = 0
                ui_butUpgrade.backgroundColor = UIColor(named: "primary")
                ui_butUpgrade.setTitleColor(UIColor.white, for: .normal)
            } else {
                ui_butUpgrade.borderWidth = 1
                ui_butUpgrade.backgroundColor = UIColor.white
                ui_butUpgrade.setTitleColor(UIColor.black, for: .normal)
            }
        }
        
        ui_butUpgrade.setTitle(butName, for: .normal)
        ui_butUpgrade.isUserInteractionEnabled = eventState
    }
}

extension membership: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as! IntroCell
        cell.entity = datasource[indexPath.row]
        return cell
    }
}

extension membership : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        progress = percent * Double(self.numberOfPages - 1)
        
        self.pageControls.forEach { (control) in
            control.progress = progress
        }
        
        self.updateButtonSetting()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = ui_collection.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.updateButtonSetting()
    }
}

