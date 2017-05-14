//
//  RoomManager.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/10.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RoomManager {
    
    private static var roomInstance: RoomManager?
    static func shareInstance() -> RoomManager {
        if roomInstance == nil {
            roomInstance = RoomManager()
        }
        return roomInstance!
    }
    
    private lazy var ref = FIRDatabase.database().reference()
    private var roomSnapShots: [FIRDataSnapshot]
    private var room: Room
    private var userSelectRoom: IndexPath
    private var roomKey: String
    
    private init () {
        roomSnapShots = []
        room = Room.init()
        userSelectRoom = IndexPath()
        roomKey = ""
    }
    
    func readAllRoom(completion: @escaping () -> Void) {
        ref.child("room").queryOrdered(byChild: "createTime").observeSingleEvent(of: .value, with: { (snapShots) in
            self.roomSnapShots.removeAll()
            for snapShot in snapShots.children.reversed() {
                self.roomSnapShots.append(snapShot as! FIRDataSnapshot)
            }
            completion()
        })
    }
    
    func getAllRoomCount() -> Int {
        return roomSnapShots.count
    }
    
    func getRoom(userSelectRoom: IndexPath? = nil) -> Room {
        if let indexPath = userSelectRoom {
            self.userSelectRoom = indexPath
            if let roomDict = roomSnapShots[self.userSelectRoom.row].value as? Dictionary<String, AnyObject> {
                room = Room(createTime: roomDict["createTime"] as! TimeInterval, currentPlayer: roomDict["currentPlayer"]! as! Dictionary<String, String>, game: roomDict["game"] as! String, location: roomDict["location"] as! String, name: roomDict["name"] as! String, ownerId: roomDict["ownerID"] as! String, players: roomDict["players"] as! Int, timePoint: roomDict["timePoint"] as! TimeInterval)
                roomKey = roomSnapShots[self.userSelectRoom.row].key
            }
        }
        return room
    }
    
    func addRoomObserve(completion: @escaping (_ alert: UIAlertController?) -> Void) {
        ref.child("room/\(roomKey)").observe(.value, with: { (snapShots) in
            if let roomDict = snapShots.value as? Dictionary<String, AnyObject> {
                self.room = Room(createTime: roomDict["createTime"] as! TimeInterval, currentPlayer: roomDict["currentPlayer"]! as! Dictionary<String, String>, game: roomDict["game"] as! String, location: roomDict["location"] as! String, name: roomDict["name"] as! String, ownerId: roomDict["ownerID"] as! String, players: roomDict["players"] as! Int, timePoint: roomDict["timePoint"] as! TimeInterval)
                if self.room.currentPlayer[Library.userInformation().uid] == nil {
                    let alert = Library.alert(title: "警告", message: "您已被移出房間😢", needButton: false)
                    completion(alert)
                } else {
                    completion(nil)
                }
            } else {
                let alert = Library.alert(message: "房間不存在或已遭刪除", needButton: false)
                completion(alert)
            }
        })
    }
    
    func removeRoomObserve() {
        ref.child("room/\(roomKey)").removeAllObservers()
    }
    
    func joinRoom(completion: @escaping (_ alert: UIAlertController?) -> Void) {
        ref.child("room/\(roomKey)/currentPlayer").updateChildValues([Library.userInformation().uid : Library.userInformation().email]) { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
    }
    
    func leaveRoom(completion: @escaping (_ alert: UIAlertController?) -> Void) {
        removeRoomObserve()
        ref.child("room/\(roomKey)/currentPlayer/\(Library.userInformation().uid)").removeValue { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteRoom(completion: @escaping (_ alert: UIAlertController?) -> Void) {
//        removeRoomObserve()
        ref.child("chat/\(roomKey)").removeValue()
        ref.child("room/\(roomKey)").removeValue { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
    }
    
    func getMessage(completion: @escaping (_ message: Dictionary<String, AnyObject>) -> Void) {
        ref.child("chat/\(roomKey)").observe(.childAdded, with: { (snapShots) in
            if let message = snapShots.value as? Dictionary<String, AnyObject> {
                completion(message)
            }
        })
    }
    
    func sendMessage(text: String, senderId: String, senderDisplayName: String, date: Date, completion: @escaping (_ alert: UIAlertController?) -> Void) {
        let randomId = ref.child("chat/\(roomKey)").childByAutoId()
        randomId.setValue(["text" : text, "senderId" : senderId, "senderDisplayName" : senderDisplayName, "date" : date.timeIntervalSince1970]) { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
    }
    
    func removePlayer(uid: String, completion: @escaping (_ alert: UIAlertController?) -> Void) {
        ref.child("room/\(roomKey)/currentPlayer/\(uid)").removeValue { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
    }
    
}
