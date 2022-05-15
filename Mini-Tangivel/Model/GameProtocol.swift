//
//  GameInterface.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 12/05/22.
//

import Foundation

protocol GameProtocol {
    associatedtype State: GameState
    associatedtype Action: GameAction
    var initial_state: State { get }
    
    func player(state: State) -> Int
    func getPossibleActions(at state: State) -> [Action]
    func perform(action: Action, at state: State) -> State
    func isGameOver(state: State) -> Bool
}

protocol GameState {
    var hashableRepresentation: AnyHashable { get }
}

protocol ConnectFourPlayer {
    mutating func getAction(at state: ConnectFour.State) -> ConnectFour.Action
}

protocol RealPlayer {}

protocol GameAction {}
