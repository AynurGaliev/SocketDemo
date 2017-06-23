//
//  ChatMessage.swift
//  SocketDemo
//
//  Created by Aynur Galiev on 14.января.2017.
//  Copyright © 2017 Aynur Galiev. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import UIKit

var swiftImage: UIImage? = {
    return UIImage(named: "swift")
}()

var vaporImage: UIImage? = {
    return UIImage(named: "vapor")
}()

final class ChatMessage: NSObject, JSQMessageData, JSQMessageAvatarImageDataSource {
    
    var message     : String
    var isIncoming  : Bool
    var senderID    : String
    var displayName : String
    var sentDate    : Date
    
    init(message: String, isIncoming: Bool, senderID: String, displayName: String, date: Date = Date()) {
        self.message = message
        self.isIncoming = isIncoming
        self.senderID = senderID
        self.displayName = displayName
        self.sentDate = date
    }
    
    func senderId() -> String! {
        return self.senderID
    }
    
    func senderDisplayName() -> String! {
        return self.displayName
    }
    
    func date() -> Date! {
        return self.sentDate
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return UInt(abs(self.senderID.hash | self.message.hash))
    }
    
    func text() -> String! {
        return self.message
    }
    
    func media() -> JSQMessageMediaData! {
        return nil
    }
    
    func avatarImage() -> UIImage! {
        if self.isIncoming {
            return vaporImage
        } else {
            return swiftImage
        }
    }
    
    func avatarHighlightedImage() -> UIImage! {
        return nil
    }
    
    func avatarPlaceholderImage() -> UIImage! {
        return nil
    }
}
