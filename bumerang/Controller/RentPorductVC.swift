//
//  RentPorductVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/24.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyJSON

class RentPorductVC: BaseViewController {
    //update by RMS
    var oneProduct : MainProductModel? = nil
    
    //@IBOutlet weak var ui_lblTotalDate: UILabel!
    @IBOutlet weak var ui_lblFromDate: UILabel!
    @IBOutlet weak var ui_lblToDate: UILabel!
    @IBOutlet weak var ui_lblRentPrice: UILabel!
    @IBOutlet weak var ui_txvMsg: UITextField!
    @IBOutlet weak var calendarView: UICollectionView!
    
    
//    @IBOutlet weak var ui_lblServicePrice: UILabel!
//    @IBOutlet weak var ui_lblTotalPrice: UILabel!

    //Calender Setup
    let cellReuseIdentifier = "CalendarDateRangePickerCell"
    let headerReuseIdentifier = "CalendarDateRangePickerHeaderView"
    
    public var delegate: CalendarDateRangePickerViewControllerDelegate!
    
    let itemsPerRow = 7
    let itemHeight: CGFloat = 40
    
    let collectionViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    public var minimumDate: Date!
    public var maximumDate: Date!
    
    public var selectedStartDate: Date?
    public var selectedEndDate: Date?
    
    public var scrollToIndex = IndexPath(item: 0, section: 0)
    public var selectedColor = UIColor(red: 66/255.0, green: 150/255.0, blue: 240/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarView()
        clearDateandPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: {
            self.view.transform = .identity
        }, completion: { (bool) in
            
            let startYear = Int(self.minimumDate!.year)
            let currentYear = Int(Date().year)
            
            let calculation : Int = ((currentYear! - startYear!) * 12) + Int(Date().month)! - 1
            
            self.calendarView.scrollToItem(at: IndexPath(item: 14, section: calculation), at: .centeredHorizontally, animated: true)
            
        })
        
    }
    
    func setCalendarView() {
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = UIColor(named: "lightgreen")
        
        calendarView.register(CalendarDateRangePickerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        calendarView.register(CalendarDateRangePickerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        calendarView.contentInset = collectionViewInsets
        
        if minimumDate == nil {
            minimumDate = Date()
        }
        if maximumDate == nil {
            maximumDate = Calendar.current.date(byAdding: .year, value: 5, to: minimumDate)
        }
    }
    
    func calulateDateAndPriceVal() {
        
        var lastDate = selectedStartDate
        if selectedEndDate != nil {
            lastDate = selectedEndDate
        }
        
        var totalDays = 1
            
        let difference = Calendar.current.dateComponents([.day], from: selectedStartDate!, to: lastDate!)
        totalDays = difference.day! + 1
        
//        totalDays = (lastDate?.interval(ofComponent: .day, fromDate: selectedStartDate!))! + 1

     //   ui_lblTotalDate.text = "\(totalDays) days"
        ui_lblFromDate.text = getStringFormDate(date: selectedStartDate!, format: "dd/MM/yyyy" )
        ui_lblToDate.text = getStringFormDate(date: lastDate!, format: "dd/MM/yyyy" )
        
        var priceOfDay : Float = oneProduct!.price
        if oneProduct?.price_type == "Hafta" {
            
            priceOfDay = oneProduct!.price / Float(7)
        } else if oneProduct?.price_type == "Gün" {
            
            priceOfDay = oneProduct!.price
        }else{
            
             priceOfDay = oneProduct!.price / Float(30)
            
            
            
        }
        
        var rentPriceVal = Float(totalDays) * priceOfDay
        rentPriceVal = rentPriceVal.roundTo(places: 2)
        ui_lblRentPrice.text = "\(rentPriceVal)"
        
        
//        var servicePrice = Float(totalDays) * priceOfDay * oneProduct!.service_fee / 100
//        servicePrice = servicePrice.roundTo(places: 2)
//        ui_lblTotalPrice.text = "\(Float(rentPriceVal + servicePrice).roundTo(places: 2))"
//        ui_lblServicePrice.text = "\(servicePrice)"
    }
    
    func clearDateandPrice() {
        
     //   ui_lblTotalDate.text = ""
       // ui_lblFromDate.text = ""
     //   ui_lblToDate.text = ""
      //  ui_lblRentPrice.text = ""
        //ui_lblTotalPrice.text = ""
        //ui_lblServicePrice.text = ""
        
    }
    
    @IBAction func onTappedRent(_ sender: UIButton) {
        
        if selectedStartDate == nil {
            self.showToast(R_EN.string.RENT_SELECT_DURING, duration: 1.5, position: .center)
        } else {
            gotoRentApi()
        }
    }
    
    func gotoRentApi() {
        
        var lastDate = selectedStartDate
        if selectedEndDate != nil {
            lastDate = selectedEndDate
        }
        
        let ownerID = "\(oneProduct!.owner_id)"
        let productID = "\(oneProduct!.product_id)"
        let startDate = getStringFormDate(date: selectedStartDate!, format: "yyyy/MM/dd" )
        let endDate = getStringFormDate(date: lastDate!, format: "yyyy/MM/dd" )
        let rent_price = ui_lblRentPrice.text!
        let userMsg = ui_txvMsg.text!
        //let serviceFee = ui_lblServicePrice.text!
        
        self.showHUD()
            
//        ProductApiManager.rentProduct(ownerID: ownerID, productID: productID, startDate: startDate, endDate: endDate, rent_price: rent_price, userMsg: userMsg, completion:  {(isSuccess, data) in
//                
//            self.hideHUD()
//            
//            if (isSuccess) {
//                
//                self.showToast(R_EN.string.RENT_SUCCESS)
//                
//            } else {
//                
//                if data == nil { self.showToast(R_EN.string.CONNECT_FAIL) }
//                else { self.showToast(JSON(data!).stringValue) }
//            }
//        })
    }
    
    @IBAction func oaTapedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RentPorductVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let difference = Calendar.current.dateComponents([.month], from: minimumDate, to: maximumDate)
        return difference.month! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let weekdayRowItems = 7
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return weekdayRowItems + blankItems + daysInMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarDateRangePickerCell
        cell.selectedColor = self.selectedColor
        cell.reset()
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        if indexPath.item < 7 {
            cell.label.text = getWeekdayLabel(weekday: indexPath.item + 1)
        } else if indexPath.item < 7 + blankItems {
            cell.label.text = ""
        } else {
            let dayOfMonth = indexPath.item - (7 + blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            cell.date = date
            cell.label.text = "\(dayOfMonth)"
            
            if isBefore(dateA: date, dateB: minimumDate) {
                cell.disable()
            }
            
            if selectedStartDate != nil && selectedEndDate != nil && isBefore(dateA: selectedStartDate!, dateB: date) && isBefore(dateA: date, dateB: selectedEndDate!) {
                // Cell falls within selected range
                if dayOfMonth == 1 {
                    cell.select()
                    //                    cell.highlight()
                    //                    cell.highlightRight()
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    cell.select()
                    //                    cell.highlight()
                    //                    cell.highlightLeft()
                } else {
                    //                    cell.highlight()
                    cell.select()
                    //                    cell.highlight()
                }
            } else if selectedStartDate != nil && areSameDay(dateA: date, dateB: selectedStartDate!) {
                // Cell is selected start date
                cell.select()
                if selectedEndDate != nil {
                    //                    cell.highlightRight()
                }
            } else if selectedEndDate != nil && areSameDay(dateA: date, dateB: selectedEndDate!) {
                cell.select()
                //                cell.highlightLeft()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = calendarView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CalendarDateRangePickerHeaderView
            headerView.label.text = getMonthLabel(date: getFirstDateForSection(section: indexPath.section))
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
}

extension RentPorductVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = calendarView.cellForItem(at: indexPath) as! CalendarDateRangePickerCell
        if cell.date == nil {
            return
        }
        if isBefore(dateA: cell.date!, dateB: minimumDate) {
            return
        }
        
        if selectedStartDate == nil {
            selectedStartDate = cell.date
            
        } else if selectedEndDate == nil {
            if isBefore(dateA: selectedStartDate!, dateB: cell.date!) {
                selectedEndDate = cell.date
                
            } else {
                // If a cell before the currently selected start date is selected then just set it as the new start date
                selectedStartDate = cell.date
            }
        } else {
            selectedStartDate = cell.date
            selectedEndDate = nil
        }
        
        self.calulateDateAndPriceVal()
        calendarView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = calendarView.frame.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: calendarView.frame.size.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension RentPorductVC {
    
    // Helper functions
    
    func getFirstDate() -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: minimumDate)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func getFirstDateForSection(section: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate())!
    }
    
    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEEE"
        //by RMS update
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date!)
    }
    
    func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }
    
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
    
}



extension UIView {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
       
        
        pulse.duration = 0.3
        pulse.fromValue = 1.5
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
  
      func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
  
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}


// Example of using the extension on button press
   
