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
        self.solver = AlphaBetaPlayer<ConnectFour>(game: game) { state in
            if let winner = state.winner {
                return Double(winner) * 900000.0
            }
            
            var sum = 0.0
            let eval_grid: [[Double]] = [[3, 4, 5, 7, 7, 5, 4, 3],
                                         [4, 6, 8, 10,10,8, 6, 4],
                                         [5, 8, 11,13,13,11,8, 5],
                                         [6, 10,14,16,16,14,10,6],
                                         [6, 10,14,16,16,14,10,6],
                                         [5, 8, 11,13,13,11,8, 5],
                                         [4, 6, 8, 10,10,8, 6, 4],
                                         [3, 4, 5, 7, 7, 5, 4, 3]]
            
            for i in 0..<state.grid.count {
                for j in 0..<state.grid[i].count {
                    if state.grid[i][j] == 1 { sum += eval_grid[i][j] }
                }
            }
            
            return sum
        }
    }
    
    mutating func selectAction(at state: ConnectFourState, from possible_actions: [ConnectFourAction]) -> ConnectFourAction {
        return solver.selectAction(at: state, from: possible_actions)
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
    
    mutating func selectAction(at state: ConnectFourState, from possible_actions: [ConnectFourAction]) -> ConnectFourAction {
        return possible_actions.first!
    }
    
}

