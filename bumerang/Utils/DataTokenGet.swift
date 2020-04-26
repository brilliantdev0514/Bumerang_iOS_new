//
//  DataTokenGet.swift
//  bumerang
//
//  Created by RMS on 11/5/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
