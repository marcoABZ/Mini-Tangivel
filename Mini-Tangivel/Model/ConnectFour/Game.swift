//
//  ConnectFourGame.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 12/05/22.
//

import Foundation

struct ConnectFour: GameProtocol {
    typealias Action = ConnectFourAction
    typealias State = ConnectFourState

    var board_width: Int
    var board_height: Int
    
    var initial_state: State {
        return State(width: board_width, height: board_height)
    }
    
    func player(state: State) -> Int {
        if state.move_count % 2 == 0 { return 1 }
            return 2
    }
    
    func getPossibleActions(at state: State) -> [ConnectFour.Action] {
        return state.getNotFilledRowsIndexes().map { Action(player: nil, column: $0) }
    }
    
    func perform(action: Action, at state: State) -> State {
        return state.dropPiece(at: action.column, player: action.player ?? 1)
    }
    
    func isGameOver(state: State) -> Bool {
        return state.is_over
    }
    
}
