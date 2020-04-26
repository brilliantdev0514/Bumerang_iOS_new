//
//  UIButton+Extension.swift
//

import Foundation
import UIKit

extension UIButton {
    
    func applyRoundShadow() {
        //self.backgroundColor = UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
}

// MARK: - round button with round shadow effect
class roundShadowButton: UIButton {
    override func didMoveToWindow() {
        self.backgroundColor =  UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
}

// MARK: - round button with drop-down shadow effect
class dropShadowDarkButton: UIButton {
    override func didMoveToWindow() {
        //self.backgroundColor =  UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

class dropShadowThemeButton: UIButton {
    override func didMoveToWindow() {
        //self.backgroundColor =  UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}
