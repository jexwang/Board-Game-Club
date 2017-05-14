//
//  RoomListTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RoomListTableViewController: UITableViewController {

    let rm = RoomManager.shareInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        SVProgressHUD.show(withStatus: "抓取資料中")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
    }
    
    func refresh() {
        rm.readAllRoom {
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rm.getAllRoomCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomListTableViewCell
        let room = rm.getRoom(userSelectRoom: indexPath)
        cell.nameLabel.text = room.name
        cell.gameLabel.text = room.game
        cell.dateLabel.text = Library.convertDate(time: room.timePoint, DateMode: .Date)
        cell.locationLabel.text = room.location
        
        let createTime = Date(timeInterval: room.createTime / 1000, since: Date(timeIntervalSince1970: 0))
        let createTimeToNow = Date().timeIntervalSince(createTime)
        switch createTimeToNow {
        case 0...59:
            cell.createTimeLabel.text = "於數秒前建立"
        case 60...3599:
            cell.createTimeLabel.text = "於 \(Int(createTimeToNow / 60)) 分鐘前建立"
        case 3600...86399:
            cell.createTimeLabel.text = "於 \(Int(createTimeToNow / 3600)) 小時前建立"
        default:
            cell.createTimeLabel.text = "於 \(Int(createTimeToNow / 86400)) 天前建立"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rm.getAllRoomCount() == 0 {
            return
        } else {
            rm.readAllRoom(completion: {
                let currentPlayer = self.rm.getRoom(userSelectRoom: indexPath).currentPlayer
                if Array(currentPlayer.keys).contains(Library.userInformation().uid) {
                    self.performSegue(withIdentifier: "Joined", sender: self)
                } else {
                    self.performSegue(withIdentifier: "RoomDetail", sender: self)
                }
            })
        }
    }
    
    @IBAction func backToRoomList(segue: UIStoryboardSegue) {
        
    }
    
}
