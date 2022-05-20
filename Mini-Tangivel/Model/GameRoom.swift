//
//  GameRoom.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import Foundation

enum Games: String, Codable {
    case connectFour = "Connect Four"
}

struct GameRoom: Codable {
    let code: String
    var hostId: String
    var opponentId: String? = nil
    
    var selectedGame: Games = .connectFour
    var isOpponentReady: Bool = false
    
    var blockedPlayersIds: [String] = []
    var winnerPlayerId: String? = nil
    
    var gameState: [Int] = []
}
