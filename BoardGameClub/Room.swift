//
//  RoomModel.swift
//  BoardGameClub
//
//  Created by 王冠綸 on 2017/3/30.
//  Copyright © 2017年 jexwang. All rights reserved.
//

import Foundation

class Room {
    var createTime: TimeInterval
    var currentPlayer: [String]
    var game: String
    var location: String
    var name: String
    var ownerID: String
    var players: Int
    var timePoint: TimeInterval
    
    init(createTime: TimeInterval, currentPlayer: [String], game: String, location: String, name: String, ownerID: String, players: Int, timePoint: TimeInterval) {
        self.createTime = createTime
        self.currentPlayer = currentPlayer
        self.game = game
        self.location = location
        self.name = name
        self.ownerID = ownerID
        self.players = players
        self.timePoint = timePoint
    }
}
