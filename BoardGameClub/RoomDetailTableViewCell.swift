//
//  RoomDetailTableViewCell.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/29.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import UIKit

class RoomDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
