//
//  CreateRoomViewController.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/25.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gameTextField: UITextField!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var pickerContainer = UIView()
    var textFieldMaxY = CGFloat()
    var movedHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = formatter.string(from: Date())
        timeTextField.text = "13:00"
        
        pickerViewInitialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let centerDefault = NotificationCenter.default
        centerDefault.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let centerDefault = NotificationCenter.default
        centerDefault.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if mainView.bounds.origin.y != 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.mainView.bounds.origin.y = 0
            })
        }
        pickerViewAnimate(mode: .down)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag < 6 {
            textFieldMaxY = textField.frame.maxY + 100
        } else {
            textFieldMaxY = textField.frame.maxY + 20
        }
        switch textField.tag {
        case 4:
            datePicker.isHidden = false
            timePicker.isHidden = true
            pickerViewAnimate(mode: .up)
            return false
        case 5:
            datePicker.isHidden = true
            timePicker.isHidden = false
            pickerViewAnimate(mode: .up)
            return false
        default:
            pickerViewAnimate(mode: .down)
            return true
        }
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        if let keyBoardHeight = (aNotification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            let visibleHeight = view.frame.maxY - (keyBoardHeight + UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!)
            if textFieldMaxY > visibleHeight {
                movedHeight = textFieldMaxY - visibleHeight
                if movedHeight > 0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainView.bounds.origin.y = 0 + self.movedHeight
                    })
                }
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.mainView.bounds.origin.y = 0
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if tag < 6 {
            let nextTextFieldTag = view.viewWithTag(tag + 1) as! UITextField
            nextTextFieldTag.becomeFirstResponder()
        } else {
            next()
        }
        return true
    }
    
    func pickerViewInitialize() {
        pickerContainer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 200)
        pickerContainer.backgroundColor = UIColor.groupTableViewBackground
        datePicker.frame = CGRect(x: 0, y: 0, width: pickerContainer.frame.width, height: pickerContainer.frame.height)
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        timePicker.frame = CGRect(x: 0, y: 0, width: pickerContainer.frame.width, height: pickerContainer.frame.height)
        timePicker.datePickerMode = .time
        timePicker.date = Calendar(identifier: .gregorian).date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        timePicker.minuteInterval = 5
        timePicker.locale = Locale(identifier: "zh_TW")
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        view.addSubview(pickerContainer)
        pickerContainer.addSubview(datePicker)
        pickerContainer.addSubview(timePicker)
    }

    enum PVAMode {
        case up
        case down
    }
    
    func pickerViewAnimate(mode: PVAMode) {
        switch mode {
        case .up:
            view.endEditing(true)
            if pickerContainer.frame.origin.y == view.frame.height {
                let visibleHeight = view.frame.maxY - 200 - (UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!)
                if textFieldMaxY > visibleHeight {
                    movedHeight = textFieldMaxY - visibleHeight
                    if movedHeight > 0 {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.mainView.bounds.origin.y = 0 + self.movedHeight
                        })
                    } else {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.mainView.bounds.origin.y = 0
                        })
                    }
                } else {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.mainView.bounds.origin.y = 0
                    })
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.pickerContainer.frame.origin.y -= self.pickerContainer.frame.height
                })
            }
        case .down:
            if pickerContainer.frame.origin.y != view.frame.height {
                UIView.animate(withDuration: 0.25, animations: {
                    self.pickerContainer.frame.origin.y += self.pickerContainer.frame.height
                })
            }
        }
    }
    
    func datePickerChanged() {
        let textField = view.viewWithTag(4) as! UITextField
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        textField.text = formatter.string(from: datePicker.date)
    }
    
    func timePickerChanged() {
        let textField = view.viewWithTag(5) as! UITextField
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        textField.text = formatter.string(from: timePicker.date)
    }

    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        next()
    }
    
    func next() {
        if nameTextField.text == "" || gameTextField.text == "" || playersTextField.text == "" || dateTextField.text == "" || timeTextField.text == "" || locationTextField.text == "" {
            let alert = UIAlertController(title: "錯誤", message: "請輸入完整資訊", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "Confirm", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Confirm" {
            let destinationController = segue.destination as! ConfirmViewController
            destinationController.name = nameTextField.text
            destinationController.game = gameTextField.text
            destinationController.players = Int(playersTextField.text!)
            destinationController.date = datePicker.date
            destinationController.time = timePicker.date
            destinationController.location = locationTextField.text
        }
    }
    
}
