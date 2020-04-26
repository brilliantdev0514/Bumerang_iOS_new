//
//  ChatVC.swift
//  bumerang
//
//  Created by RMS on 2019/9/12.
//  Copyright © 2019 RMS. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Foundation
class ChatListVC: BaseViewController, ChatListCellDelegate{
    
    

    let databaseChats = Constants.refs.databaseRoot.child("Bumerang_chat")
    var chatlistData = [ChatListModel]()
    
    @IBOutlet weak var ui_searchBar: UISearchBar!
    @IBOutlet weak var ui_chatdata_coll: UICollectionView!
    @IBOutlet weak var outerview: UIView!
    @IBOutlet weak var autoview: UIView!
    @IBOutlet weak var nomessageimage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListdata()
        self.view.bringSubviewToFront(outerview)
        
        
    }
    //MARK:- trashBtnPressed function!
    func btnCloseTapped(cell: ChatListCell) {
                let alertController = UIAlertController(title: nil, message:
                    "Mesajı silmek istiyor musunuz?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Evet", style: UIAlertAction.Style.default,handler: {(action) -> Void in
                let uid = Auth.auth().currentUser!.uid
                let receivedId = cell.entity.senderId
                let room_id = "\(uid)_\(receivedId)"
                Database.database().reference().child("message").child(room_id).removeValue()
            }))
            alertController.addAction(UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil))
    
                self.present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- chat list data load function here
    func loadListdata() {
//        for i in 0 ..< 0 {
//            
//            let one = ChatListModel(senderId: Defaults[.userId], receiverId: i, imgName: "avatar_1", username: "user \(i)", contentStr: "hey, what are you doing now?", reqDate: "1hr ago", unreadNum: i)
//            chatlistData.append(one)
//        }
//        
//        ui_chatdata_coll.reloadData()
        let chatList = Database.database().reference().child("message")
        
        let uid = Auth.auth().currentUser!.uid
        let receiveUserId: String = ""
        let room_id = "\(uid)_\(receiveUserId)"


        chatList.observe(.value, with: { (snapshot) in
                  // Get user value
                    if !snapshot.exists() {
                        // handle data not found
                        return
                    }
            self.chatlistData.removeAll()
                    
            let chatList = snapshot.children.allObjects as! [DataSnapshot]
            for data in chatList{                
                
                print(data)
                for data2 in data.children.allObjects as! [DataSnapshot] {
                    let key = data.key
                    let myId = key.components(separatedBy: "_")[0]
                    if myId == uid {
                        if let data2 = data2.value as? [String: AnyObject] {
                                                    
                                    var bIsSame = false
                                    for chatRoomModel in self.chatlistData {
                                        
                                        if data2["name"] as? String != nil && chatRoomModel.username ==  data2["name"] as? String {
                                            
                                            bIsSame = true;
                                            break
                                        }
                                    }
                                    
                                    if (!bIsSame) {
                                        
                                        let objFirt = ChatListModel.parseMessageData(ary: NSArray(object: data2)).object(at: 0)
                                        if data2["name"]as? String != (ShareData.user_info.first_name + " " + ShareData.user_info.last_name)
                                        {
                                            self.chatlistData.append(objFirt as! ChatListModel)
                                            
                                        }
                                    }
                                
                            }
                        }
                    }
                    
                    
                
            }
            
            //let chatData = snapshot.value as! [String: String]
        //          Users user = Users.init(dict: value)
            self.ui_chatdata_coll.reloadData()
//            DispatchQueue.main.async {
//                print("------------")
//                print(self.chatlistData.count)
//
//            }
            
            
            if self.chatlistData.count == 0 {
                
                self.view.bringSubviewToFront(self.outerview)
               
                
            }else{
             
                
                self.autoview.bringSubviewToFront(self.autoview)
                self.outerview.isHidden = true
                //self.outerview.removeFromSuperview()
                
            }
            
                  // ...
                  })
    }
    
    @IBAction func onClickPluse(_ sender: Any) {
        self.gotoNavigationScreen("CatagorySelectVC", direction: .fromLeft)
    }
    
    @IBAction func onClickChart(_ sender: Any) {
                
        self.gotoTabVC("MainpageAfterNav")
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        
        
        
    }
    
    @IBAction func onClickRend(_ sender: Any) {
        //self.gotoTabVC("RentHistoryNav")

        let toSearch = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        //toSearch.delegate = self
        self.modalPresentationStyle = .fullScreen
        self.present(toSearch, animated: true, completion: nil)
    }
    
    @IBAction func onClickMyProfile(_ sender: Any) {
        
        self.gotoMyInfoVC(oneProduct: nil)
        
    }
    //MARK:- handle gesture
    @IBAction func handleGesture(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizer.State.began
        {
            
                let alertController = UIAlertController(title: nil, message:
                    "Are you sure delete?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {(action) -> Void in
               
//                let uid = Auth.auth().currentUser!.uid
//                let receivedId = self.entity.senderId
//                let room_id = "\(uid)_\(receivedId)"
//                Database.database().reference().child("message").child(room_id).removeValue()
                self.viewDidLoad()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
    
                self.present(alertController, animated: true, completion: nil)
        }


        }
    
    
}

extension ChatListVC : UISearchBarDelegate {
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
    }
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
    }
}
//MARK:- go to chat room vc
extension ChatListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //
        Database.database().reference().child("BlockedUsers").observeSingleEvent(of: .value, with: { (snapshot) in
                                      // Get user value
                                        if !snapshot.exists() {
                                            // handle data not found
                                            let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                                            toVC.receiveUserId = self.chatlistData[indexPath.row].senderId
                                            
                                            self.navigationController?.pushViewController(toVC, animated: true)
                                            return
                                        }
            var groupNames = ""
                                        for group in snapshot.children {
                                            groupNames.append((group as AnyObject).key)
                                        }
                                        print(groupNames)
            let uid = Auth.auth().currentUser!.uid
            if (groupNames.contains(uid + "_" + self.chatlistData[indexPath.row].senderId) ||
                groupNames.contains(self.chatlistData[indexPath.row].senderId + "_" + uid)) {
                self.showToast("Kullanıcı engellendi. Yaşadığınız sorunlardan dolayı özür dileriz")
            } else {

                let toVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                toVC.receiveUserId = self.chatlistData[indexPath.row].senderId
                
                self.navigationController?.pushViewController(toVC, animated: true)
            }
                                      }) { (error) in
                                        print(error.localizedDescription)
                                    }
        //
        
        
        
    }
    
}

extension ChatListVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return chatlistData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        
        cell.entity = self.chatlistData[indexPath.row]
        cell.delegate = self

        return cell
        
    }
}


extension ChatListVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        let h : CGFloat = 100
        return CGSize(width: w, height: h)
    }
}
