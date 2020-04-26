//
//  String+Extention.swift
//  bumerang
//
//  Created by RMS on 2019/10/2.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation

extension String {
    
    func split(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
    func splitByLength(_ length: Int, seperator: String) -> [String] {
        var result = [String]()
        var collectedWords = [String]()
        collectedWords.reserveCapacity(length)
        var count = 0
        let words = self.components(separatedBy: " ")
        
        for word in words {
            count += word.count + 1 //add 1 to include space
            if (count > length) {
                // Reached the desired length
                
                result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
                collectedWords.removeAll(keepingCapacity: true)
                
                count = word.count
                collectedWords.append(word)
            } else {
                collectedWords.append(word)
            }
        }
        
        // Append the remainder
        if !collectedWords.isEmpty {
            result.append(collectedWords.map { String($0) }.joined(separator: seperator))
        }
        
        return result
    }
    
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


extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
    
    func encodeString() -> String? {
        
        let customAllowedSet =  NSCharacterSet(charactersIn:"!*'();:@&=+$,/?%#[] ").inverted
        return addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
        
        if decodedStr != nil {
            return decodedStr!
        }
        
        return self
    }
    
    var encodeEmoji: String {
        
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) as String?
        
        if encodedStr != nil {
            return encodedStr!
        }
        
        return self
    }
}
