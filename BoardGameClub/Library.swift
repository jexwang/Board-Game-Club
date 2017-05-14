//
//  AppTemp.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/23.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import Firebase

class Library {
    enum DateMode {
        case Date
        case Time
    }
    
    static func convertDate(time: TimeInterval, DateMode: DateMode) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        switch DateMode {
        case .Date:
            formatter.dateFormat = "yyyy/MM/dd"
        case .Time:
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
    
    static func alert(title: String = "錯誤", message: String, needButton: Bool) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if needButton {
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
        }
        return alert
    }
    
    static func userInformation() -> (uid: String, email: String) {
        let user = FIRAuth.auth()!.currentUser!
        return (user.uid, user.email!)
    }
    
    static func signIn(email: String, password: String, completion: @escaping ( _ sucess: Bool, _ alert: UIAlertController?) -> Void) {
        var isSuccess: Bool!
        var alert: UIAlertController?
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                isSuccess = false
                if var errorMessage = error?.localizedDescription {
                    if errorMessage.contains("The password is invalid") {
                        errorMessage = "密碼錯誤"
                    }
                    if errorMessage.contains("There is no user record") {
                        errorMessage = "查無此帳號，或者帳號已遭刪除"
                    }
                    alert = self.alert(message: errorMessage, needButton: true)
                }
                completion(isSuccess, alert)
            } else {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                getUserInformation(uid: userInformation().uid) { (user) in
                    userNickname = user["nickname"] as! String
                }
                isSuccess = true
                completion(isSuccess, alert)
            }
        })
    }
    
    static let ref = FIRDatabase.database().reference()
    static var userNickname: String!
    
    static func getUserInformation(uid: String, completion: @escaping (_ user: Dictionary<String, AnyObject>) -> Void) {
        ref.child("userInformation").child(uid).observeSingleEvent(of: .value, with: { (snapShots) in
            if let user = snapShots.value as? Dictionary<String, AnyObject> {
                completion(user)
            }
        })
    }
    
    static func modifyNickname(nickname: String, completion: @escaping (_ alert: UIAlertController?) -> Void) {
        ref.child("userInformation/\(userInformation().uid)").updateChildValues(["nickname" : nickname]) { (error, ref) in
            if error != nil {
                let alert = Library.alert(message: "修改失敗，請重試", needButton: true)
                completion(alert)
            } else {
                userNickname = nickname
                completion(nil)
            }
        }
    }
    
    static func dateStringToTimeInterval(date: Date, time: Date) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateArray = dateFormatter.string(from: date).components(separatedBy: "/")
        dateFormatter.dateFormat = "HH:mm"
        let timeArray = dateFormatter.string(from: time).components(separatedBy: ":")
        let timePoint = Calendar(identifier: .gregorian).date(from: DateComponents(year: Int(dateArray[0]), month: Int(dateArray[1]), day: Int(dateArray[2]), hour: Int(timeArray[0]), minute: Int(timeArray[1])))
        return timePoint!.timeIntervalSince1970
    }
}

@IBDesignable
class strokeLabel: UILabel {
    
    @IBInspectable
    open var strokeColor: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var strokeWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawText(in rect: CGRect) {
        //保存文字顏色
        let textColor = self.textColor
        
        let c = UIGraphicsGetCurrentContext()!
        c.setLineWidth(strokeWidth)
        c.setLineJoin(.round)
        
        //畫外框
        c.setTextDrawingMode(.stroke)
        self.textColor = strokeColor
        super.drawText(in: rect)
        
        //畫文字本體
        c.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
}
