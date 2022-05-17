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
    
    func getPossibleActions(at state: State) -> [ConnectFour.Action] {
        return state.getNotFilledRowsIndexes().map { Action(column: $0) }
    }
    
    func perform(action: Action, at state: State) -> State {
        return state.dropPiece(at: action.column)
    }
    
    func isGameOver(state: State) -> Bool {
        return state.is_over
    }
    
}
