//
//  InformationViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/26.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import FirebaseAuth

class InformationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        try? FIRAuth.auth()!.signOut()
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
    }

}
