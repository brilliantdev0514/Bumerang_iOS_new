//
//  ChatListModel.swift
//  bumerang
//
//  Created by RMS on 2019/9/12.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation

class ChatListModel {
    
    var senderId : String = ""
    var receiverId : String = ""
    var imgName : String = ""
    var username : String = "User Name"
    var contentStr : String = "Hi, Are you there?"
    var reqDate : String = "1hr ago"
    var unreadNum : Int = 1
    var user_name = ""
    
    
    /*init(senderId : String, receiverId : String, imgName : String, username : String, contentStr :String, reqDate :String, unreadNum : Int) {
        
        self.senderId = senderId
        self.receiverId = receiverId
        self.imgName = imgName
        self.username = username
        self.contentStr = contentStr
        self.reqDate = reqDate
        self.unreadNum = unreadNum
        
//        var dateStrArr = self.updated_at.split(withMaxLength: 19)
//        self.updated_at = dateStrArr[0]
        
    }*/
    
    init(senderId : String, receiverId : String, imgName : String, username : String, contentStr :String) {
            
            self.senderId = senderId
            self.imgName = imgName
            self.username = username
            self.contentStr = contentStr
            
        }
    
    class func parseMessageData(ary: NSArray) -> NSMutableArray {
        
        let muary = NSMutableArray()
        
        for index in 0 ..< ary.count {
            
            let dict = ary.object(at: index) as! [String: Any]
            
            let objList = ChatListModel(senderId: DataChecker .getValidationstring(dict: dict, key: "sender_id"), receiverId: "", imgName: DataChecker.getValidationstring(dict: dict, key: "photo"), username: DataChecker .getValidationstring(dict: dict, key: "name"), contentStr: DataChecker .getValidationstring(dict: dict, key: "message"))
            
            
            muary.add(objList)
        }
        
        return muary
    }
    
    
}

