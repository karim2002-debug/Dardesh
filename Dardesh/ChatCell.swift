//
//  ChatCell.swift
//  Dardesh
//
//  Created by Macbook on 21/09/2024.
//

import UIKit

class ChatCell: UITableViewCell {

    enum BubbelType{
        case incoming
        case outcoming
    }
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
        userNameLabel.text = model.senderName
        messageTextView.text = model.messageText
    }
    
    func setBubble(type : BubbelType){
        
        if type == .incoming{
            chatStack.alignment = .trailing
            chatTextContainer.backgroundColor = .systemGreen
            messageTextView.textColor = .white
        }else if type == .outcoming{
            chatStack.alignment = .leading
            chatTextContainer.backgroundColor = .darkGray
            messageTextView.textColor = .white
        }
        
    }
    
    

}
