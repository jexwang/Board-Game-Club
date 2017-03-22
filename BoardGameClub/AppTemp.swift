//
//  AppTemp.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/23.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import Foundation

class AppTemp {
    enum DateMode: String {
        case Date = "date"
        case Time = "time"
    }
    
    static func convertDate(time: TimeInterval, DateMode: DateMode) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        switch DateMode.rawValue {
        case "date":
            formatter.dateFormat = "yyyy/MM/dd"
        case "time":
            formatter.dateFormat = "HH:mm"
        default:
            break
        }
        return formatter.string(from: date)
    }
}
