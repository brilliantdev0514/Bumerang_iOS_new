//
//  Introduction1VC.swift
//  bumerang
//
//  Created by RMS on 2019/9/3.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import CHIPageControl

class IntroductionVC: BaseViewController {

    internal let numberOfPages = 4
    var progress = 0.0
    
    @IBOutlet var pageControls: [CHIBasePageControl]!
    @IBOutlet weak var ui_collection: UICollectionView!
    @IBOutlet weak var ui_skipBut: UIButton!
    
    var datasource = [IntroModel]()
    
    let imgNames = ["splash_1", "splash_2", "splash_3", "splash_4"]
    let topicStr = ["Kiralamanın en iyi yolu", "Kiralayarak kazan", "Satın alma, kirala", "Güvenli mobil platform"]
    let contentStr = [
        "Bumerang’la Türkiye’nin her yerinden kiralık ürün ve hizmet sağlayıcılarına bir tıkla ulaşmanın kolaylığını yaşa!",
        "İster bireysel olarak kiralayın, ister kurumsal olarak. Online mağazanızı açmak hiç bu kadar kolay olmamıştı. Bumerang herkese açık!",
        "Satın almak geçmişte kaldı. Şimdi ihtiyacınız olan her şeye kısa veya uzun dönem kiralayarak ulaşın. Tonla para vermekten kurtulun!",
        "Doğrulamalı üyelik sayesinde güvenli bir platformda bulunmanın rahatlığını yaşayın!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageControls.forEach { (control) in
            control.numberOfPages = self.numberOfPages
        }
        
        for i in 0 ..< imgNames.count {
            
            let one = IntroModel(imgName: imgNames[i], topicStr: topicStr[i], contentStr: contentStr[i])
            datasource.append(one)
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        
        progress += 1.0
        if progress == 4.0 {
            gotoMainBeforeVC()
            return
        }
        ui_collection.scrollToItem(at: IndexPath.init(row: Int(progress), section: 0) , at: .centeredHorizontally, animated: true)
        self.pageControls.forEach { (control) in
            control.progress = progress
        }
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
       gotoMainBeforeVC()
      //  gotoTabVC("MainpageAfterNav")
    }

    func showSkipButton() {
        if progress < 3.0 {
            ui_skipBut.isHidden = false
        } else {
            ui_skipBut.isHidden = true
        }
    }
    
}

extension IntroductionVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        progress = percent * Double(self.numberOfPages - 1)
        
        self.pageControls.forEach { (control) in
            control.progress = progress
        }
        
        showSkipButton()
    }
}

extension IntroductionVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        let h = collectionView.frame.size.height
        
        return CGSize(width: w, height: h)
    }
}
