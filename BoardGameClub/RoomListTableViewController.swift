//
//  RoomListTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase

class RoomListTableViewController: UITableViewController {
    
    let ref = FIRDatabase.database().reference()
    var contentArray: [FIRDataSnapshot] = []
    var snap: FIRDataSnapshot!

    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Firebase load data
    
    func read() {
        ref.child("room").observe(.value, with: { (snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                self.snap = snapShots
            }
            self.reload(snap: self.snap)
        })
    }
    
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            contentArray.removeAll()
            for item in snap.children {
                contentArray.append(item as! FIRDataSnapshot)
            }
            ref.child("room").keepSynced(true)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        } else {
            contentArray.removeAll()
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomListTableViewCell
        let room = contentArray[indexPath.row].value as! Dictionary<String, AnyObject>
        cell.nameLabel.text = String(describing: room["name"]!)
        cell.gameLabel.text = String(describing: room["game"]!)
        cell.dateLabel.text = AppTemp.convertDate(time: room["timePoint"] as! TimeInterval, DateMode: .Date)
        cell.locationLabel.text = String(describing: room["location"]!)
        let createTime = Date(timeInterval: room["createTime"] as! TimeInterval / 1000, since: Date(timeIntervalSince1970: 0))
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
    
    @IBAction func backToRoomList(segue: UIStoryboardSegue) {
        
    }
    
}
