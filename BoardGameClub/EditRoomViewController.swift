//
//  EditRoomViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/10.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditRoomViewController: UIViewController {

    let rm = RoomManager.shareInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteRoomButton(_ sender: UIButton) {
        let alert = Library.alert(title: "警告", message: "確認是否要刪除", needButton: false)
        alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: {_ in
            SVProgressHUD.show(withStatus: "刪除中")
            self.rm.deleteRoom(completion: { (alert) in
                if alert != nil {
                    SVProgressHUD.dismiss()
                    self.present(alert!, animated: true, completion: nil)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "已刪除")
                    SVProgressHUD.dismiss(withDelay: 1)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
                        let _ = self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
