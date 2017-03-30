//
//  LoginViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
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
            view.endEditing(true)
            SVProgressHUD.show(withStatus: "登入中")
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "登入成功")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.userDefaults.set(self.emailTextField.text, forKey: "email")
                    self.userDefaults.synchronize()
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                        self.performSegue(withIdentifier: "Login", sender: self)
                    })
                }
            })
        }
    }
    
    @IBAction func resetPwButton(_ sender: UIButton) {
        
    }
    
    @IBAction func backToLoginView(segue: UIStoryboardSegue) {
        
    }

}
