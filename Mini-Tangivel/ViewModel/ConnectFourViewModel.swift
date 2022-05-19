//
//  ConnectFourViewModel.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import SwiftUI

class ConnectFourViewModel: ObservableObject {
    
    private var game: ConnectFour
    private var player_1: ConnectFourPlayer
    private var player_2: ConnectFourPlayer
    private var next_player: ConnectFourPlayer
    private var peripheral: PeripheralViewModel
    
    @Published private(set) var currentGameState: ConnectFourState {
        didSet {
            if !currentGameState.is_over {
                if var player = next_player as? AlphaBetaConnectFourPlayer {
                    let possible_actions = game.getPossibleActions(at: currentGameState)
                    let selected_action = player.selectAction(at: currentGameState, from: possible_actions)
                    next_player = currentGameState.move_count % 2 == 0 ? player_2 : player_1
                    currentGameState = game.perform(action: selected_action, at: currentGameState)
                    peripheral.send(selected_action.column, color: UIColor.red)
                }
            }
        }
    }
    
    init(game: ConnectFour, player_1: ConnectFourPlayer, player_2: ConnectFourPlayer) {
        self.game = game
        self.currentGameState = game.initial_state
        self.player_1 = player_1
        self.player_2 = player_2
        self.next_player = player_1
        self.peripheral = PeripheralViewModel()
        peripheral.delegate = self
        connect()
    }
    
    func startGame() {
        resetGame()
        
        if var player = next_player as? AlphaBetaConnectFourPlayer {
            let possible_actions = game.getPossibleActions(at: currentGameState)
            let selected_action = player.selectAction(at: currentGameState, from: possible_actions)
            next_player = currentGameState.move_count % 2 == 0 ? player_2 : player_1
            currentGameState = game.perform(action: selected_action, at: currentGameState)
            peripheral.send(selected_action.column, color: UIColor.red)
        }
    }
    
    func check(action: ConnectFourAction) {
        guard let _ = next_player as? RealConnectFourPlayer else { return }
        if currentGameState.is_over { return }
        
        let possible_actions = game.getPossibleActions(at: currentGameState)
        if possible_actions.contains(action) {
            next_player = currentGameState.move_count % 2 == 0 ? player_2 : player_1
            currentGameState = game.perform(action: action, at: currentGameState)
        }
    }
    
    func resetGame() {
        game = ConnectFour(board_width: 8, board_height: 8)
        next_player = player_1
        currentGameState = game.initial_state
        peripheral.send(9, color: UIColor.white)
    }
}

extension ConnectFourViewModel: PeripheralViewModelDelegate {
    
    func handleClick(at row: Int) {
        next_player = currentGameState.move_count % 2 == 0 ? player_2 : player_1
        currentGameState = game.perform(action: ConnectFourAction(column: row), at: currentGameState)
        print(currentGameState.move_count)
        print(next_player)
    }
    
    func connect() {
        peripheral.connectCalculator()
    }
}
