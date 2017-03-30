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
    
    let ref = FIRDatabase.database().reference()
    var name: String!
    var game: String!
    var players: Int!
    var date: Date!
    var time: Date!
    var location: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        nameLabel.text = "\(name!)"
        gameLabel.text = "遊戲: \(game!)"
        playersLabel.text = "人數: \(players!)"
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLabel.text = "日期: \(dateFormatter.string(from: date!))"
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = "時間: \(dateFormatter.string(from: time!))"
        locationLabel.text = "\(location!)"
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        SVProgressHUD.show(withStatus: "建立中")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateArray = dateFormatter.string(from: date).components(separatedBy: "/")
        dateFormatter.dateFormat = "HH:mm"
        let timeArray = dateFormatter.string(from: time).components(separatedBy: ":")
        let timePoint = Calendar(identifier: .gregorian).date(from: DateComponents(year: Int(dateArray[0]), month: Int(dateArray[1]), day: Int(dateArray[2]), hour: Int(timeArray[0]), minute: Int(timeArray[1])))
        
        let conditionRef = ref.child("room")
        let roomID = conditionRef.childByAutoId()
        roomID.setValue(["ownerID" : FIRAuth.auth()!.currentUser!.uid,
                         "createTime" : FIRServerValue.timestamp(),
                         "name" : name,
                         "game" : game,
                         "players" : players,
                         "timePoint" : timePoint!.timeIntervalSince1970,
                         "location" : location,
                         "currentPlayer" : [
                            "0" : FIRAuth.auth()!.currentUser!.email]
            ]) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "建立完成")
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }

}
