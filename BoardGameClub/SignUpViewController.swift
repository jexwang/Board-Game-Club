//
//  SignUpViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        pwTextField.text = ""
        confirmPwTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard emailTextField.text != "" else {
            let alert = UIAlertController(title: "錯誤", message: "請輸入E-Mail和密碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard pwTextField.text == confirmPwTextField.text else {
            let alert = UIAlertController(title: "錯誤", message: "確認密碼失敗", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        SVProgressHUD.show(withStatus: "註冊中")
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "註冊成功", message: "請按確定登入", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "確定", style: .default, handler: { _ in
                    SVProgressHUD.show(withStatus: "登入中")
                    Library.signIn(email: self.emailTextField.text!, password: self.pwTextField.text!, completion: { (isSucess, alert) in
                        if isSucess {
                            SVProgressHUD.showSuccess(withStatus: "登入成功")
                            SVProgressHUD.dismiss(withDelay: 1)
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                                self.performSegue(withIdentifier: "SignUpLogin", sender: self)
                            })
                        } else {
                            SVProgressHUD.dismiss()
                            self.present(alert!, animated: true, completion: nil)
                        }
                    })
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
}
