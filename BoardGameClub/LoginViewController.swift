//
//  LoginViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    let userDefaults = UserDefaults.standard
    let svp = SVProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        if let email = userDefaults.string(forKey: "email") {
            emailTextField.text = email
        }
//        pwTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if emailTextField.text == "" || pwTextField.text == "" {
            let alert = UIAlertController(title: "錯誤", message: "請輸入E-Mail和密碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            SVProgressHUD.show(withStatus: "登入中")
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                if error == nil {
                    self.view.endEditing(true)
                    SVProgressHUD.showSuccess(withStatus: "登入成功")
                    SVProgressHUD.dismiss(withDelay: 1)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                        self.performSegue(withIdentifier: "Login", sender: self)
                    })
                } else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func resetPwButton(_ sender: UIButton) {
        
    }
    
    @IBAction func backToLoginView(segue: UIStoryboardSegue) {
        
    }

}
