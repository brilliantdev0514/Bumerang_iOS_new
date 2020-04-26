	//
//  Double+Extension.swift
//  bumerang
//
//  Created by RMS on 2019/9/27.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
extension Float {
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
    
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
