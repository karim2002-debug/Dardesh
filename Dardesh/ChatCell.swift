//
//  ChatCell.swift
//  Dardesh
//
//  Created by Macbook on 21/09/2024.
//

import UIKit
enum BubbelType{
    case incoming
    case outcoming
}
class ChatCell: UITableViewCell {

   
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var chatTextContainer: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTextContainer.layer.cornerRadius = 7
    }

    
    func configerCell(with model : Message){
        print(model)
        userNameLabel.text = model.senderName
        messageTextView.text = model.messageText
        guard let time = model.time else{
            return
        }
        setData(currentTime: time) { result in
            self.currentTimeLabel.text = result
        }
        
    }
    func setData(currentTime : Double , completion : @escaping (_ result : String)->()){
        let data = Date(timeIntervalSince1970: currentTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dataString = dateFormatter.string(from: data)
        completion(dataString)
    }
    func setBubble(type : BubbelType){
        
        if type == .incoming{
            chatStack.alignment = .trailing
            chatTextContainer.backgroundColor = .systemGreen
            messageTextView.textColor = .white
            currentTimeLabel.textColor = .white
        }else if type == .outcoming{
            chatStack.alignment = .leading
            chatTextContainer.backgroundColor = .darkGray
            messageTextView.textColor = .white
            currentTimeLabel.textColor = .white
        }
    }

}
