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

    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailLabel.text = "帳號: \(FIRAuth.auth()!.currentUser!.email!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        try? FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
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
