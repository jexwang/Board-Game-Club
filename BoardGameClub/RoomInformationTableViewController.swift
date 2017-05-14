//
//  RoomInformationTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/10.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import MapKit

class RoomInformationTableViewController: UITableViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    func roomRenew() {
        mapRefresh()
        tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomInformationTableViewCell", for: indexPath) as! RoomDetailTableViewCell
        let room = rm.getRoom()
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "房間名稱："
            cell.contentLabel.text = "\(room.name)"
        case 1:
            cell.titleLabel.text = "遊戲名稱："
            cell.contentLabel.text = "\(room.game)"
        case 2:
            cell.titleLabel.text = "玩家人數："
            cell.contentLabel.text = "\(room.players)"
        case 3:
            cell.titleLabel.text = "日期："
            cell.contentLabel.text = "\(Library.convertDate(time: room.timePoint, DateMode: .Date))"
        case 4:
            cell.titleLabel.text = "時間："
            cell.contentLabel.text = "\(Library.convertDate(time: room.timePoint, DateMode: .Time))"
        case 5:
            cell.titleLabel.text = "地點："
            cell.contentLabel.text = "\(room.location)"
        default:
            break
        }
        return cell
    }
}
