//
//  InTheRoomViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/30.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
//import FirebaseDatabase

class InTheRoomViewController: UIViewController {
    
    @IBOutlet weak var chatRoomContainerView: UIView!
    @IBOutlet weak var playerListContainerView: UIView!
    @IBOutlet weak var roomInformationContainerView: UIView!
    
    let rm = RoomManager.shareInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rm.addRoomObserve { (alert) in
            if alert != nil {
                self.view.endEditing(true)
                let alertAction = UIAlertAction(title: "確定", style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alert!.addAction(alertAction)
                self.present(alert!, animated: true, completion: nil)
            } else {
                let notificationName = Notification.Name("RoomRenew")
                NotificationCenter.default.post(name: notificationName, object: nil)
                let room = self.rm.getRoom()
                self.navigationItem.title = room.name
                if room.ownerId == Library.userInformation().uid {
                    let rightBarButtonItem = UIBarButtonItem(title: "編輯房間", style: .plain, target: self, action: #selector(self.editRoomButton))
                    self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
                } else {
                    let rightBarButtonItem = UIBarButtonItem(title: "離開房間", style: .plain, target: self, action: #selector(self.leaveRoomButton))
                    self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
                }
            }
        }
        
        let backButton = UIBarButtonItem(title: "＜遊戲列表", style: .plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        rm.removeRoomObserve()
    }
    
    func backButtonAction() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func editRoomButton() {
        performSegue(withIdentifier: "EditRoom", sender: self)
    }
    
    func leaveRoomButton() {
        rm.leaveRoom { (alert) in
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func roomSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chatRoomContainerView.isHidden = false
            playerListContainerView.isHidden = true
            roomInformationContainerView.isHidden = true
        case 1:
            view.endEditing(true)
            chatRoomContainerView.isHidden = true
            playerListContainerView.isHidden = false
            roomInformationContainerView.isHidden = true
        case 2:
            view.endEditing(true)
            chatRoomContainerView.isHidden = true
            playerListContainerView.isHidden = true
            roomInformationContainerView.isHidden = false
        default:
            break
        }
    }

}
