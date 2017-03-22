//
//  SignUpViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/22.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
        if emailTextField.text == "" {
            let alert = UIAlertController(title: "錯誤", message: "請輸入E-Mail和密碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if pwTextField.text != confirmPwTextField.text {
            let alert = UIAlertController(title: "錯誤", message: "確認密碼失敗", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pwTextField.text!, completion: { (user, error) in
                if error == nil {
                    let alert = UIAlertController(title: "註冊成功", message: "請按確定並登入", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "確定", style: .default, handler: { _ in
                        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.pwTextField.text!, completion: { (user, error) in
                            self.performSegue(withIdentifier: "SignUpLogin", sender: self)
                        })
                    })
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
}
