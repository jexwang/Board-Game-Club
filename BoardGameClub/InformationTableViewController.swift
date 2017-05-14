//
//  InformationTableViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/13.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import SVProgressHUD
//import FirebaseStorageUI

class InformationTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = Library.userInformation().email
        nicknameLabel.text = Library.userNickname
        
//        let userImageName = "\(Library.userInformation().uid).jpg"
//        let reference = FIRStorage.storage().reference().child("images/\(userImageName)")
//        if let placeholderImage = UIImage(named: "\(userImageName)") {
//            imageView.layer.cornerRadius = self.imageView.frame.width / 2
//            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
//        }
        StorageManager.downloadImage(uid: Library.userInformation().uid) { (image, alert) in
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
            } else {
                self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
                self.imageView.image = image!
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let height = view.frame.height * 0.4
            return height
        } else {
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                SVProgressHUD.show(withStatus: "讀取相簿中")
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                SVProgressHUD.dismiss()
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let imageData = UIImageJPEGRepresentation(selectImage, 0.6) {
                SVProgressHUD.show(withStatus: "上傳中")
                StorageManager.uploadImage(uid: Library.userInformation().uid, data: imageData, contentType: "image/jpeg", completion: { (alert) in
                    if alert != nil {
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                        self.present(alert!, animated: true, completion: nil)
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "上傳成功")
                        SVProgressHUD.dismiss(withDelay: 1)
                        self.imageView.image = selectImage
                        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }

    @IBAction func nicknameButton(_ sender: UIButton) {
        if sender.title(for: .normal) == "修改暱稱" {
            nicknameLabel.isHidden = true
            nicknameTextField.isHidden = false
            sender.setTitle("確定", for: .normal)
            nicknameTextField.becomeFirstResponder()
        } else {
            guard nicknameTextField.text != "" else {
                present(Library.alert(message: "請輸入暱稱", needButton: true), animated: true, completion: nil)
                return
            }
            
            Library.modifyNickname(nickname: nicknameTextField.text!, completion: { (alert) in
                if alert != nil {
                    self.present(alert!, animated: true, completion: nil)
                } else {
                    self.view.endEditing(true)
                    self.nicknameLabel.text = self.nicknameTextField.text
                    self.nicknameTextField.text = ""
                    self.nicknameLabel.isHidden = false
                    self.nicknameTextField.isHidden = true
                    sender.setTitle("修改暱稱", for: .normal)
                }
            })
        }
    }
    

}
