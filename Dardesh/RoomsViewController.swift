//
//  RoomsViewController.swift
//  Dardesh
//
//  Created by Macbook on 17/09/2024.
//


// 1- refence from data base
// 2- create name of the database
// 2- ( dataArry ) we are setvalue
import UIKit
import Firebase
class RoomsViewController: UIViewController {
    
    
    var rooms = [Room]()
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        obserRooms()
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            presentFormVC()
        }
    }
    @IBAction func didTapedLogoutButton(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        
        presentFormVC()
    }
    
    func obserRooms(){
        
        let ref = Database.database().reference()
        ref.child("Rooms").observe(.childAdded) { snapshot   in
            if let dataArray = snapshot.value as? [String : Any]{
                if let roomsName = dataArray["roomName"] as? String {
                    let room = Room(roomID: snapshot.key, roomName: roomsName)
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentFormVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "FromVC")as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func didTapedCreateRoomButton(_ sender: UIButton) {
        
        guard let roomName = roomNameTextField.text , roomName.isEmpty == false else{
            return
        }
        let ref = Database.database().reference()
        let rooms = ref.child("Rooms").childByAutoId()
        let dataArray : [String : Any] = ["roomName":roomName]
        rooms.setValue(dataArray) { error, ref in
            if let error = error{
                print(error)
            }else{
                self.roomNameTextField.text = ""
            }
        }
        
    }
    
}
extension RoomsViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = rooms[indexPath.row]
        let chatRoomVC = storyboard?.instantiateViewController(withIdentifier: "chatRoomVC")as!ChatRoomViewController
        chatRoomVC.room = selectedRoom
        navigationController?.pushViewController(chatRoomVC, animated: true)
    }
}
