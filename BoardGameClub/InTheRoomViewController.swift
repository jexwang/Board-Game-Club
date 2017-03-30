//
//  InTheRoomViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/30.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit

class InTheRoomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "＜遊戲列表", style: .plain, target: self, action: #selector(backButtonAction))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonAction() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
