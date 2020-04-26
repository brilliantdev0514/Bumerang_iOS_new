//
//  Extensions.swift
//  bumerang
//
//  Created by RMS on 2019/9/10.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit






extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension String {
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var lines: [String] {
        return components(separatedBy: CharacterSet.newlines)
    }
    
    public var firstLine: String? {
        return lines.first?.trimmed
    }
    
    public var lastLine: String? {
        return lines.last?.trimmed
    }
    
    public func replaceNewLineCharater(separator: String = " ") -> String {
        return components(separatedBy: CharacterSet.whitespaces).joined(separator: separator).trimmed
    }
    
    public func replacePunctuationCharacters(separator: String = "") -> String {
        return components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: separator).trimmed
    }
}

