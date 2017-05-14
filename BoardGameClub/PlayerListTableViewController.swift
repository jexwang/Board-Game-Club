//
//  PlayerListTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/10.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit

class PlayerListTableViewController: UITableViewController {
    
    let rm = RoomManager.shareInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationName = Notification.Name("RoomRenew")
        NotificationCenter.default.addObserver(self, selector: #selector(roomRenew), name: notificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        rm.removeRoomObserve()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roomRenew() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rm.getRoom().currentPlayer.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as! PlayerListTableViewCell
        let room = rm.getRoom()
        let uid = Array(room.currentPlayer.keys)[indexPath.row]
        if uid.contains("@") == false {
            Library.getUserInformation(uid: uid) { (user) in
                var nickname = user["nickname"] as! String
                if uid == room.ownerId {
                    nickname = "\(nickname)(室長)"
                }
                cell.playerLabel.text = nickname
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let room = rm.getRoom()
        let uid = Array(room.currentPlayer.keys)[indexPath.row]
        let ownerId = rm.getRoom().ownerId
        if Library.userInformation().uid == ownerId && uid != ownerId {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeBotton = UITableViewRowAction(style: .destructive, title: "移除玩家") { (action, indexPath) in
            let uid = Array(self.rm.getRoom().currentPlayer.keys)[indexPath.row]
            self.rm.removePlayer(uid: uid, completion: { (alert) in
                if alert != nil {
                    self.present(alert!, animated: true, completion: nil)
                }
            })
        }
        return [removeBotton]
    }

}
