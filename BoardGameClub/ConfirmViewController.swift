//
//  ConfirmViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/25.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ConfirmViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "\(room.name)"
        gameLabel.text = "遊戲: \(room.game)"
        playersLabel.text = "人數: \(room.players)"
        dateLabel.text = "日期: \(Library.convertDate(time: room.timePoint, DateMode: .Date))"
        timeLabel.text = "時間: \(Library.convertDate(time: room.timePoint, DateMode: .Time))"
        locationLabel.text = "\(room.location)"
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        SVProgressHUD.show(withStatus: "建立中")
        
        let ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()!.currentUser!
        
        let conditionRef = ref.child("room")
        let roomID = conditionRef.childByAutoId()
        roomID.setValue(["ownerID" : user.uid,
                         "createTime" : FIRServerValue.timestamp(),
                         "name" : room.name,
                         "game" : room.game,
                         "players" : room.players,
                         "timePoint" : room.timePoint,
                         "location" : room.location,
                         "currentPlayer" : [user.uid : user.email]]) { (error, ref) in
                            if error != nil {
                                print(error!)
                            } else {
                                SVProgressHUD.showSuccess(withStatus: "建立完成")
                                self.dismiss(animated: true, completion: nil)
                            }
        }
    }
    
}
