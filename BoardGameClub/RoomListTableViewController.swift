//
//  RoomListTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RoomListTableViewController: UITableViewController {
    
    let ref = FIRDatabase.database().reference()
    var contentArray: [FIRDataSnapshot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(read), for: .valueChanged)
        self.refreshControl = refreshControl
        
        read()
        
        SVProgressHUD.show(withStatus: "抓取資料中")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        read()
    }
    
    // MARK: - Firebase load data
    
    func read() {
        ref.child("room").queryOrdered(byChild: "createTime").observeSingleEvent(of: .value, with: { (snapShots) in
            if snapShots.children.allObjects is [FIRDataSnapshot] {
                let snap = snapShots
                self.reload(snap: snap)
            }
        })
    }
    
    func reload(snap: FIRDataSnapshot) {
        if snap.exists() {
            contentArray.removeAll()
            for item in snap.children.reversed() {
                contentArray.append(item as! FIRDataSnapshot)
            }
            ref.child("room").keepSynced(true)
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            SVProgressHUD.dismiss(withDelay: 1)
        } else {
            contentArray.removeAll()
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            SVProgressHUD.dismiss(withDelay: 1)
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
        if let room = contentArray[indexPath.row].value as? Dictionary<String, AnyObject> {
            cell.nameLabel.text = room["name"] as! String?
            cell.gameLabel.text = room["game"] as! String?
            cell.dateLabel.text = AppTemp.convertDate(time: room["timePoint"] as! TimeInterval, DateMode: .Date)
            cell.locationLabel.text = room["location"] as! String?
            
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
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let room = contentArray[indexPath.row].value as? Dictionary<String, AnyObject> {
            let currentPlayer = room["currentPlayer"] as! [String]
            if currentPlayer.contains(FIRAuth.auth()!.currentUser!.email!) {
                performSegue(withIdentifier: "Joined", sender: self)
            } else {
                performSegue(withIdentifier: "RoomDetail", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let destinationController = segue.destination as! RoomDetailViewController
            destinationController.roomKey = contentArray[indexPath.row].key
            destinationController.roomDict = contentArray[indexPath.row].value as! Dictionary<String, AnyObject>
        }
    }
    
    @IBAction func backToRoomList(segue: UIStoryboardSegue) {
        
    }
    
}
