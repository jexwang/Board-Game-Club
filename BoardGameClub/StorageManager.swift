//
//  StorageManager.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/4/13.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageManager {
    
    static let storageRef = FIRStorage.storage().reference()
    
    static func uploadImage(uid: String, data: Data, contentType: String?, completion: @escaping (_ alert: UIAlertController?) -> Void) {
        let tempData = data as NSData
        guard tempData.length < 1 * 1024 * 1024 else {
            let length = Float(tempData.length) / 1024 / 1024
            let lengthString = String(format: "%.1f", length)
            let alert = Library.alert(message: "選擇的照片大小為\(lengthString)MB，請勿超過1MB", needButton: true)
            completion(alert)
            return
        }
        let imageRef = storageRef.child("images/\(uid).jpg")
        let metadata = FIRStorageMetadata()
        metadata.contentType = contentType
        let uploadTask = imageRef.put(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                completion(alert)
            } else {
                completion(nil)
            }
        }
        uploadTask.resume()
    }
    
    static func downloadImage(uid: String, completion: @escaping (_ image: UIImage?, _ alert: UIAlertController?) -> Void) {
        let imageRef = storageRef.child("images/\(uid).jpg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                if error!.localizedDescription.contains("does not exist.") == false {
                    let alert = Library.alert(message: error!.localizedDescription, needButton: true)
                    completion(nil, alert)
                }
                print("return")
                return
            } else {
                let image = UIImage(data: data!)
                completion(image, nil)
            }
        }
        
    }
    
}
