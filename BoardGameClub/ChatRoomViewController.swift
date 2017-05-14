//
//  ChatRoomViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/9.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
//import FirebaseDatabase
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController {
    
    let rm = RoomManager.shareInstance()
    let notificationName = Notification.Name("LoadCompletion")
    let avatarSize = kJSQMessagesCollectionViewAvatarSizeDefault * 1.5
    var message: [Dictionary<String, AnyObject>] = []
    var avatarImageDict: Dictionary<String, UIImage> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: avatarSize, height: avatarSize)
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: avatarSize, height: avatarSize)
        senderId = Library.userInformation().uid
        senderDisplayName = Library.userNickname
        
        rm.getMessage { (message) in
            self.message.append(message)
            self.finishReceivingMessage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        rm.removeRoomObserve()
    }
    
    func avatarImageCache(uid: String, completion: @escaping (_ needReload: Bool) -> Void) {
        if avatarImageDict[uid] != nil {
            completion(false)
        } else {
            StorageManager.downloadImage(uid: uid) { (image, alert) in
                if alert != nil {
                } else {
                    if let avatarImage = JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: UInt(self.avatarSize)) {
                        self.avatarImageDict[uid] = avatarImage
                        completion(true)
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        let message = self.message[indexPath.row]
        guard let senderID = message["senderId"] as? String, let senderDisplayName = message["senderDisplayName"] as? String, let date = message["date"] as? TimeInterval, let text = message["text"] as? String else {
            return JSQMessage(senderId: "", displayName: "", text: "")
        }
        let dateToNow = Date(timeIntervalSince1970: date)
        return JSQMessage(senderId: senderID, senderDisplayName: senderDisplayName, date: dateToNow, text: text)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        let message = self.message[indexPath.row]
        let factory = JSQMessagesBubbleImageFactory()
        if message["senderId"] as! String == senderId {
            return factory!.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        } else {
            return factory!.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = self.message[indexPath.row]
        let name = message["senderDisplayName"] as! String
        let date = Library.convertDate(time: message["date"] as! TimeInterval, DateMode: .Time)
        let bubbleTopLabelString = "\(name) - \(date)"
        return NSAttributedString(string: bubbleTopLabelString)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.message[indexPath.row]
        let uid = message["senderId"] as! String
        let avatarImage = JSQMessagesAvatarImage.init(avatarImage: avatarImageDict[uid], highlightedImage: avatarImageDict[uid], placeholderImage: UIImage(named: "photoalbum"))
        avatarImageCache(uid: uid) { (reload) in
            if reload {
                collectionView.reloadItems(at: [indexPath])
            }
        }
        return avatarImage
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        rm.sendMessage(text: text, senderId: senderId, senderDisplayName: senderDisplayName, date: date) { (alert) in
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            } else {
                self.finishSendingMessage()
            }
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        print("not in use")
    }
    
}
