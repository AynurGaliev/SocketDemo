//
//  ViewController.swift
//  SocketDemo
//
//  Created by Aynur Galiev on 14.января.2017.
//  Copyright © 2017 Aynur Galiev. All rights reserved.
//

import UIKit
import SocketRocket
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {

    fileprivate var socket: SRWebSocket?
    fileprivate var messages: [ChatMessage] = []
    private let bubbleFactory = JSQMessagesBubbleImageFactory()
    private lazy var incomingImage: JSQMessagesBubbleImage? = {
        return self.bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.white)
    }()
    private lazy var outgoingImage: JSQMessagesBubbleImage? = {
        return self.bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red: 16/255, green: 41/255, blue: 143/255, alpha: 1))
    }()
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "Chat_Client"
        self.senderDisplayName = "Chat client"
        self.incomingCellIdentifier = "incoming_cell"
        self.outgoingCellIdentifier = "outgoing_cell"
        
        let incomingCellNib = UINib.init(nibName: "JSQMessagesCollectionViewCellIncoming", bundle: Bundle(for: JSQMessagesCollectionViewCellIncoming.self))
        self.collectionView.register(incomingCellNib, forCellWithReuseIdentifier: self.incomingCellIdentifier)
        let outgoingCellNib = UINib.init(nibName: "JSQMessagesCollectionViewCellOutgoing", bundle: Bundle(for: JSQMessagesCollectionViewCellOutgoing.self))
        self.collectionView.register(outgoingCellNib, forCellWithReuseIdentifier: self.outgoingCellIdentifier)
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 25, height: 25)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 25, height: 25)
        
        let background = UIImageView(frame: self.collectionView.bounds)
        background.contentMode = .scaleToFill
        background.image = UIImage(named: "winter.jpeg")
        self.collectionView.backgroundView = background
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.socket = SRWebSocket(url: URL(string: "ws://booksshop.herokuapp.com/socket"))
        self.socket?.delegate = self
        self.socket?.open()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if cell is JSQMessagesCollectionViewCellOutgoing {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        cell.avatarImageView.layer.cornerRadius = self.collectionView.collectionViewLayout.incomingAvatarViewSize.height/2
        cell.avatarImageView.contentMode = .scaleAspectFit
        cell.avatarImageView.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let chatMessage: ChatMessage = self.messages[indexPath.row]
        
        if chatMessage.isIncoming {
            return self.incomingImage
        } else {
            return self.outgoingImage
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let chatMessage = self.messages[indexPath.row]
        let text = "\(chatMessage.displayName), \(self.dateFormatter.string(from: chatMessage.sentDate))"
        return NSAttributedString.init(string: text, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14),
                                                       NSForegroundColorAttributeName : UIColor.white])
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return self.messages[indexPath.row]
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let chatMessage = ChatMessage(message: text, isIncoming: false, senderID: self.senderId, displayName: self.senderDisplayName)
        self.messages.append(chatMessage)
        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
 
        self.finishSendingMessage()
//            self.scrollToBottom(animated: true)
 
        self.socket?.send(chatMessage.message)
    }
    
    deinit {
        self.socket?.close()
    }
}

extension ChatViewController: SRWebSocketDelegate {
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let chatMessage = ChatMessage(message: message as! String, isIncoming: true, senderID: "Chat_Server", displayName: "Chat Server")
        self.messages.append(chatMessage)
        self.finishReceivingMessage()
        self.collectionView.reloadData()
        self.scrollToBottom(animated: true)
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("Socket failed. Error - \(error)")
        //self.socket?.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("Socket closed. Code - \(code), reason - \(reason), clean - \(wasClean)")
        //self.socket?.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        
    }
    
    func webSocketShouldConvertTextFrame(toString webSocket: SRWebSocket!) -> Bool {
        return true
    }
}
