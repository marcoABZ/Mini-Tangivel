//
//  AlphaBetaPlayer.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import Foundation

struct AlphaBetaConnectFourPlayer: ConnectFourPlayer {
    
    private var solver: AlphaBetaPlayer<ConnectFour>
    
    init(game: ConnectFour) {
        self.solver = AlphaBetaPlayer<ConnectFour>(game: game) { _ in 1 }
    }
    
    mutating func getAction(at state: ConnectFour.State) -> ConnectFour.Action {
        return solver.getAction(at: state)
    }
    
}

struct RealConnectFourPlayer: ConnectFourPlayer, RealPlayer {
    
    private var game: ConnectFour
    
    init(game: ConnectFour) {
        self.game = game
    }
    
    func check(action: ConnectFourAction, at state: ConnectFourState) -> Bool {
        return game.getPossibleActions(at: state).contains { $0 == action }
    }
    
    internal mutating func getAction(at state: ConnectFour.State) -> ConnectFour.Action { return ConnectFourAction(player: nil, column: 0) }
}

