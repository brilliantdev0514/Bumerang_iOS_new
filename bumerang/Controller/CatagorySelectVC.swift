//
//  CatagorySelectVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/7.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit

class CatagorySelectVC: BaseViewController {

    @IBOutlet weak var ui_houseView: UIView!
    @IBOutlet weak var ui_carView: UIView!
    @IBOutlet weak var ui_caravanView: UIView!
    @IBOutlet weak var ui_shipView: UIView!
    @IBOutlet weak var ui_dressView: UIView!
    @IBOutlet weak var ui_bikeView: UIView!
    @IBOutlet weak var ui_camaraView: UIView!
    @IBOutlet weak var ui_campView: UIView!
    @IBOutlet weak var ui_musicView: UIView!
    @IBOutlet weak var ui_otherView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let cataColor = Constants.cataColor
        
        ui_houseView.cornerRadius = ui_houseView.bounds.height / 2
        ui_houseView.backgroundColor = UIColor(rgb: cataColor[0])
        
        ui_carView.cornerRadius = ui_carView.bounds.height / 2
        ui_carView.backgroundColor = UIColor(rgb: cataColor[1])
        
        ui_caravanView.cornerRadius = ui_caravanView.bounds.height / 2
        ui_caravanView.backgroundColor = UIColor(rgb: cataColor[2])
        
        ui_shipView.cornerRadius = ui_shipView.bounds.height / 2
        ui_shipView.backgroundColor = UIColor(rgb: cataColor[3])
        
        ui_dressView.cornerRadius = ui_dressView.bounds.height / 2
        ui_dressView.backgroundColor = UIColor(rgb: cataColor[4])
        
        ui_bikeView.cornerRadius = ui_bikeView.bounds.height / 2.1
        ui_bikeView.backgroundColor = UIColor(rgb: cataColor[5])
        
        ui_camaraView.cornerRadius = ui_camaraView.bounds.height / 2
        ui_camaraView.backgroundColor = UIColor(rgb: cataColor[6])
        
        ui_campView.cornerRadius = ui_campView.bounds.height / 2
        ui_campView.backgroundColor = UIColor(rgb: cataColor[7])
        
        ui_musicView.cornerRadius = ui_musicView.bounds.height / 2
        ui_musicView.backgroundColor = UIColor(rgb: cataColor[8])
        
        ui_otherView.cornerRadius = ui_otherView.bounds.height / 2
        ui_otherView.backgroundColor = UIColor(rgb: cataColor[9])
    }
    
    @IBAction func onClickhouse(_ sender: Any) {
        gotoNavigationScreen("AddApartmentFlatVC", direction: .fromLeft)
    }
    
    @IBAction func onClickCar(_ sender: Any) {
        gotoNavigationScreen("AddCarVC", direction: .fromLeft)
    }
    
    @IBAction func onClickCaravan(_ sender: Any) {
        gotoNavigationScreen("AddCaravanVC", direction: .fromLeft)
    }
    
    @IBAction func onClickShip(_ sender: Any) {
        gotoNavigationScreen("AddSeaVehicleVC", direction: .fromLeft)
    }
    
    @IBAction func onClickDress(_ sender: Any) {
        gotoNavigationScreen("AddClothVC", direction: .fromLeft)
    }
    
    @IBAction func onClickBike(_ sender: Any) {
        gotoNavigationScreen("AddBikeVC", direction: .fromLeft)
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        gotoNavigationScreen("AddCameraVC", direction: .fromLeft)
        
    }
    
    @IBAction func onClickKamp(_ sender: Any) {
        gotoNavigationScreen("AddKampVC", direction: .fromLeft)
    }
    
    @IBAction func onClickMusic(_ sender: Any) {
        gotoNavigationScreen("AddMusicVC", direction: .fromLeft)
    }
    
    @IBAction func onClickOther(_ sender: Any) {
        gotoNavigationScreen("AddOtherVC", direction: .fromLeft)
    }
}
