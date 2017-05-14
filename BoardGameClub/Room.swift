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
    var currentPlayer: Dictionary<String, String>
    var game: String
    var location: String
    var name: String
    var ownerId: String
    var players: Int
    var timePoint: TimeInterval
    
    init(createTime: TimeInterval = 1, currentPlayer: Dictionary<String, String> = ["playerUid" : "playerEmail"], game: String = "game", location: String = "Taiwan", name: String = "name", ownerId: String = "onwerId", players: Int = 1, timePoint: TimeInterval = 1) {
        self.createTime = createTime
        self.currentPlayer = currentPlayer
        self.game = game
        self.location = location
        self.name = name
        self.ownerId = ownerId
        self.players = players
        self.timePoint = timePoint
    }
}
