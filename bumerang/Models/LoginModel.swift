//
//  LoginModel.swift
//  bumerang
//
//  Created by RMS on 10/23/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
class LoginModel {
    
    var fname: String = ""
    var lname: String = ""
    var email: String = ""
    var pwd: String = ""
    
    init(fname : String, lname :String, email : String, pwd : String) {
        
        self.fname = fname
        self.lname = lname
        self.email = email
        self.pwd = pwd
    }
}
