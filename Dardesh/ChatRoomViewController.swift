//
//  ChatRoomViewController.swift
//  Dardesh
//
//  Created by Macbook on 19/09/2024.
//

import UIKit
import Firebase
class ChatRoomViewController: UIViewController {
    
    
    var room : Room?
    var messages = [Message]()
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var chatTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        sendView.layer.cornerRadius = 20
        title = room?.roomName
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observMessages()
        
    }
    
    
    // to get the userName whose send the message
    func getUserNameWithId(userID : String , completion : @escaping (_ userName : String?) -> Void){
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(userID)
        user.child("userName").observeSingleEvent(of: .value) { snapshot  in
            if let userName = snapshot.value as? String{
                completion(userName)
            }else{
                completion(nil)
            }
        }
    }
    
    func sendMessage(text : String , completion :@escaping (_ isSuccess : Bool) -> ()){
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        // after getting the userName(we will go to the room -> we will create the messages at datebase with autogentatedKey and but n the message database -> userName and text )
        getUserNameWithId(userID: userID) { userName in
            if let userName = userName{
                // which we will send to database (message with sender name and text)
                let currentTime = Date().timeIntervalSince1970
                let dataArray : [String : Any] = ["senderName" : userName , "text" : text , "senderID" : userID , "time" : currentTime ]
                if let roomID = self.room?.roomID {
                    let ref = Database.database().reference()
                    let room = ref.child("Rooms").child(roomID)
                    room.child("messages").childByAutoId().setValue(dataArray) { error, ref in
                        if let error = error{
                            print(error)
                            completion(false)
                        }else{
                            completion(true)
                            self.chatTextField.text = ""
                        }
                    }
                }
            }
        }
    }
    
    func observMessages(){
        guard let roomID = room?.roomID else{
            return
        }
        let databaseRef = Database.database().reference()
        let messages = databaseRef.child("Rooms").child(roomID).child("messages").observe(.childAdded) { [self] snapshot , _ in
            print(snapshot )
            if let dataArray  = snapshot.value as? [String : Any]{
                guard let senderName = dataArray["senderName"] as? String , let messageText = dataArray["text"] as? String ,  let senderID = dataArray["senderID"] as? String , let currentTime = dataArray["time"]as? Double else{
                    return
                }
                
                
                let message = Message(messageKey: snapshot.key , senderName: senderName,messageText: messageText , userID: senderID,time: currentTime)
                self.messages.append(message)
                self.chatTableView.reloadData()
            }
       
        }
    }
    
    @IBAction func didTapedSendButtojn(_ sender: UIButton) {
        
        guard let chatText = chatTextField.text , chatText.isEmpty == false else{
            return
        }
        
        sendMessage(text: chatText) { isSuccess in
            if isSuccess{
                print("Success")
            }
        }
    }
}
extension ChatRoomViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell")as! ChatCell
        let message = messages[indexPath.row]
        
        cell.configerCell(with: message)
        
        if message.userID == Auth.auth().currentUser?.uid{
            cell.setBubble(type: .outcoming)

        }else{
            cell.setBubble(type: .incoming)

        }
        
        return cell
    }
    
}
