//
//  RoomDetailViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/26.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class RoomDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roomDetailTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var roomKey: String!
    var roomDict: Dictionary<String, AnyObject>!
    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()

        room = Room(createTime: roomDict["createTime"] as! TimeInterval, currentPlayer: roomDict["currentPlayer"] as! [String], game: roomDict["game"] as! String, location: roomDict["location"] as! String, name: roomDict["name"] as! String, ownerID: roomDict["ownerID"] as! String, players: roomDict["players"] as! Int, timePoint: roomDict["timePoint"] as! TimeInterval)
        
        roomDetailTableView.estimatedRowHeight = 44
        roomDetailTableView.rowHeight = UITableViewAutomaticDimension
        roomDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(room.location) { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tableView.restorationIdentifier! {
        case "RoomDetailTableView":
            return 6
        case "CurrentPlayerTableView":
            return room.currentPlayer.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.restorationIdentifier! {
        case "RoomDetailTableView":
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDetailTableViewCell", for: indexPath) as! RoomDetailTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "房間名稱:"
                cell.contentLabel.text = "\(room.name)"
            case 1:
                cell.titleLabel.text = "遊戲名稱:"
                cell.contentLabel.text = "\(room.game)"
            case 2:
                cell.titleLabel.text = "玩家人數:"
                cell.contentLabel.text = "\(room.players)"
            case 3:
                cell.titleLabel.text = "日期:"
                cell.contentLabel.text = "\(AppTemp.convertDate(time: room.timePoint, DateMode: .Date))"
            case 4:
                cell.titleLabel.text = "時間:"
                cell.contentLabel.text = "\(AppTemp.convertDate(time: room.timePoint, DateMode: .Time))"
            case 5:
                cell.titleLabel.text = "地點:"
                cell.contentLabel.text = "\(room.location)"
            default:
                break
            }
            return cell
        case "CurrentPlayerTableView":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentPlayerTableViewCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "玩家列表: (\(room.currentPlayer.count)/\(room.players))"
            } else {
                cell.textLabel?.text = room.currentPlayer[indexPath.row - 1]
            }
            return cell
        default:
            return UITableViewCell()
        } 
    }
    
    @IBAction func joinButton(_ sender: UIBarButtonItem) {
        if room.currentPlayer.count < room.players {
            let ref = FIRDatabase.database().reference().child("room").child(roomKey).child("currentPlayer")
            ref.updateChildValues(["\(room.currentPlayer.count)" : FIRAuth.auth()!.currentUser!.email!], withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.performSegue(withIdentifier: "Join", sender: self)
                }
            })
        } else {
            let alert = UIAlertController(title: "錯誤", message: "遊戲人數已滿", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}
