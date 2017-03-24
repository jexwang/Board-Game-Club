//
//  AppTemp.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/23.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit

class AppTemp {
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
