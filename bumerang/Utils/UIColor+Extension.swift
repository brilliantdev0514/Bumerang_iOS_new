//
//  Color+Extension.swift
//
//

import Foundation
import UIKit
//import UIColor_Hex_Swift
//typealias AppColorList = UIColor.LocalColorName

extension UIColor {

    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    
    
//    enum LocalColorName: String {
//        
//        case themeColor  = "#87A85F"
//        case lightThemeColor = "#9cb57d"
//        case loginPlaceholderColor = "#BCC8AF"
//        case darkButton = "#596473"
//        case settingsFont = "#dce0e6"
//    }
//    
//    convenience init(name: LocalColorName) {
//        //self.init(name.rawValue)
//        self.init(name: UIColor.LocalColorName(rawValue: name.rawValue)!)
//    }
}
