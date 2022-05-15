//
//  ConnectFourViewModel.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import SwiftUI

class ConnectFourViewModel: ObservableObject {
    
    @Published var game: ConnectFour
    private var player_1: ConnectFourPlayer
    private var player_2: ConnectFourPlayer
    
    @Published private(set) var currentGameState: ConnectFourState {
        didSet {
            if game.player(state: currentGameState) == 1 {
                if var player = player_1 as? AlphaBetaConnectFourPlayer {
                    perform(action: player.getAction(at: currentGameState))
                }
            }
            if game.player(state: currentGameState) == 2 {
                if var player = player_2 as? AlphaBetaConnectFourPlayer {
                    perform(action: player.getAction(at: currentGameState))
                }
            }
            if game.isGameOver(state: currentGameState) {
                resetGame()
            }
        }
    }
    
    init(game: ConnectFour, player_1: ConnectFourPlayer, player_2: ConnectFourPlayer) {
        self.game = game
        self.currentGameState = game.initial_state
        self.player_1 = player_1
        self.player_2 = player_2
        
        if var player = player_1 as? AlphaBetaConnectFourPlayer {
            perform(action: player.getAction(at: currentGameState))
        }
    }
    
    func perform(action: ConnectFourAction) {
        let player = game.player(state: currentGameState) == 1 ? player_1 : player_2
        var actionCopy = action
        actionCopy.player = game.player(state: currentGameState) == 1 ? 1 : -1
        
        if let player = player as? RealConnectFourPlayer {
            if player.check(action: action, at: currentGameState) {
                currentGameState = game.perform(action: actionCopy, at: currentGameState)
                return
            }
        }
        
        currentGameState = game.perform(action: actionCopy, at: currentGameState)
        return
    }
    
    func resetGame() {
        game = ConnectFour(board_width: 8, board_height: 8)
        currentGameState = game.initial_state
    }
}
