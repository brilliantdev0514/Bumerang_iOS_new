//
//  ChatRoomVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/13.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import FirebaseDatabase
import FirebaseAuth

class ChatRoomVC: BaseViewController {
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtMsg: UITextField!
    
    var chatList:[ChatRoomModel] = [ChatRoomModel]()
    
    let userId = Auth.auth().currentUser!.uid
    var receiveUserId: String = ""
    var room_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        tblChat.estimatedRowHeight = 100
        
        room_id = "\(userId)_\(receiveUserId)"
        
        fetchMessage()
        fetchStatus(status: "online")
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        fetchStatus(status: "offline")
        Database.database().reference().child("notification").child("\(userId)").removeValue()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
//        for index in 0 ..< 6 {
//
//            let senderId = (index % 2 == 0 ? userId : receiveUserId)
//            let receiverId = (index % 2 == 0 ? receiveUserId : userId)
//            var string = "\(index) \n" + "Nice to meet you"
//            if index % 2 == 0 {
//
//                string += "\n" + "Nice to meet you, Nice to meet you, Nice to meet you,Nice to meet you"
//                string += "\n" + "Nice to meet you"
//                string += "\n" + "Nice to meet you"
//            }
//
//            let tmp = ChatRoomModel(senderId: senderId, receiverId: receiverId, strDate: getCurrentDateStr(), strMsg: string, userImageUrl: "")
//
//            chatList.append(tmp)
//        }
//
//        tblChat.reloadData()
    }
    
    
    func fetchStatus(status : String)
    {
        Database.database().reference().child("status").child(room_id).removeValue()
        let status_Data = ["online" : status,
                           "sender_id" : "\(userId)",
                            "time" : Date().toMillis()!] as [String : Any]
        let key4 = Database.database().reference().child("status").child(room_id).childByAutoId().key!
        Database.database().reference().child("status").child(room_id).child(key4).setValue(status_Data)
        
    }
    
    func fetchMessage() {
        
        chatList.removeAll()
        
        let database = Database.database().reference()
        database.child("message")
        .child(room_id)
        .observe(.childAdded) { (snapshot) in
            
            print("snapshot===", snapshot.value ?? "" as Any)
            if let messageData = snapshot.value as? [String: AnyObject] {
                let objFirt = ChatRoomModel.parseMessageData(ary: NSArray(object: messageData)).object(at: 0)
                self.chatList.append(objFirt as! ChatRoomModel)
            }
            self.chatList = self.chatList.sorted(by: { $0.time < $1.time })
            self.tblChat.reloadData()
            self.tblChat.scroll(to: .bottom, animated: true)
        }
    }
    
    @IBAction func onClickSend(_ sender: Any) {
        if checkValid() {
            doSend()
        }
    }
    
    func checkValid() -> Bool {
        
        self.view.endEditing(true)
        
        if txtMsg.text!.isEmpty {
            
            let message = "Message content is empty."
            
            showToast(message)
            
            return false
        }
        return true
    }
    
    func doSend() {
        let messageData1 = ["message" : txtMsg.text!,
                           "image": "",
                           "name": ShareData.user_info.first_name + " " + ShareData.user_info.last_name,
                           "sender_id" : "\(userId)" ,
                           "photo" : ShareData.user_info.avatarUrl! ,
                           "time" : Date().toMillis()!] as [String : Any]

        let key1 = Database.database().reference().child("message").child(room_id).childByAutoId().key!
        Database.database().reference().child("message").child(room_id).child(key1).setValue(messageData1)
        
        let room_id1 = "\(receiveUserId)_\(userId)"
        
        let messageData2 = ["message" : txtMsg.text!,
                           "image": "",
                           "name": ShareData.user_info.first_name + " " + ShareData.user_info.last_name,
                           "sender_id" : "\(userId)" ,
                           "photo" : ShareData.user_info.avatarUrl! ,
                           "time" : Date().toMillis()!] as [String : Any]

        let key2 = Database.database().reference().child("message").child(room_id1).childByAutoId().key!
        Database.database().reference().child("message").child(room_id1).child(key2).setValue(messageData2)
        
        let notification_Data = ["message" : txtMsg.text!,
                                 "sender_id" : "\(userId)",
                                "sender_name" : ShareData.user_info.first_name + " " + ShareData.user_info.last_name,
                                "sender_photo" : ShareData.user_info.avatarUrl!,
                                "time" : Date().toMillis()!] as [String : Any]
        let key3 = Database.database().reference().child("notification").child("\(receiveUserId)").child("\(userId)").childByAutoId().key!
        Database.database().reference().child("notification").child("\(receiveUserId)").child("\(userId)").child(key3).setValue(notification_Data)
        
//        //let timeNow = Int(NSDate().timeIntervalSince1970)
//
//        var chatObject = [String: String]()
//
//        chatObject["userid"] = "1"
//        chatObject["msgContent"] = txtMsg.text! as String
//
//        let chatRoomId = "1_10"
//
//        FirebaseAPI.sendMessage(chatObject, chatRoomId) { (status, message) in
//
//            if status {
                self.txtMsg.text = ""
//                print(message)
//            } else {
//                print(message)
//            }
//        }
    }
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatList[indexPath.row].senderId == "\(self.userId)" { // sending cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendingCell", for: indexPath) as! SendingCell
            
            cell.setCell(chat: chatList[indexPath.row])
            
            return cell
            
        } else { // receiving cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivingCell", for: indexPath) as! ReceivingCell
            
            cell.setCell(chat: chatList[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate func scrollToBottom(){
        let index:IndexPath = IndexPath(row: chatList.count, section: 0)
        tblChat.scrollToRow(at: index, at: .bottom, animated: true)
    }
}

extension ChatRoomVC: UITextFieldDelegate {
    // MARK: - UITextField delegate
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == txtMsg) {
            if (checkValid()) {
                self.doSend()
            }
        }
        
        return true
    }
}
