//
//  RoomDetailViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/26.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
//import FirebaseDatabase
import SVProgressHUD
import MapKit

class RoomDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roomDetailTableView: UITableView!
    @IBOutlet weak var currentPlayerTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let rm = RoomManager.shareInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rm.addRoomObserve { (alert) in
            if alert != nil && alert!.message!.contains("移出") == false {
                let alertAction = UIAlertAction(title: "確定", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alert!.addAction(alertAction)
                self.present(alert!, animated: true, completion: nil)
            } else {
                self.roomDetailTableView.reloadData()
                self.currentPlayerTableView.reloadData()
                self.mapRefresh()
            }
        }
        
        roomDetailTableView.estimatedRowHeight = 44
        roomDetailTableView.rowHeight = UITableViewAutomaticDimension
        roomDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        rm.removeRoomObserve()
    }
    
    func mapRefresh() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(rm.getRoom().location) { (placemarks, error) in
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
            return rm.getRoom().currentPlayer.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rm.getRoom()
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
                cell.contentLabel.text = "\(Library.convertDate(time: room.timePoint, DateMode: .Date))"
            case 4:
                cell.titleLabel.text = "時間:"
                cell.contentLabel.text = "\(Library.convertDate(time: room.timePoint, DateMode: .Time))"
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
                let room = room.currentPlayer
                Library.getUserInformation(uid: Array(room.keys)[indexPath.row - 1], completion: { (user) in
                    cell.textLabel?.text = user["nickname"] as? String
                })
            }
            return cell
        default:
            return UITableViewCell()
        } 
    }
    
    @IBAction func joinButton(_ sender: UIBarButtonItem) {
        let room = rm.getRoom()
        if room.currentPlayer.count < room.players {
            SVProgressHUD.show(withStatus: "加入中")
            let randomSecond: TimeInterval = Double(arc4random_uniform(20)) * 0.1 + 1
            Timer.scheduledTimer(withTimeInterval: randomSecond, repeats: false, block: { _ in
                if room.currentPlayer.count < room.players {
                    self.rm.joinRoom(completion: { (alert) in
                        if alert != nil {
                            SVProgressHUD.dismiss()
                            self.present(alert!, animated: true, completion: nil)
                        } else {
                            SVProgressHUD.showSuccess(withStatus: "加入成功")
                            SVProgressHUD.dismiss(withDelay: 1)
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                                self.performSegue(withIdentifier: "Join", sender: self)
                            })
                        }
                    })
                } else {
                    SVProgressHUD.dismiss()
                    self.present(Library.alert(message: "遊戲人數已滿", needButton: true), animated: true, completion: nil)
                }
            })
        } else {
            present(Library.alert(message: "遊戲人數已滿", needButton: true), animated: true, completion: nil)
        }
    }

}
