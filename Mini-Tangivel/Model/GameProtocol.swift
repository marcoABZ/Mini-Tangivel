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
    
    func getPossibleActions(at state: State) -> [Action]
    func perform(action: Action, at state: State) -> State
    func isGameOver(state: State) -> Bool
}

protocol GameState: Codable {
    var hashableRepresentation: AnyHashable { get }
}

protocol ConnectFourPlayer {
    mutating func selectAction(at state: ConnectFourState, from possible_actions: [ConnectFourAction]) -> ConnectFourAction
}

protocol RealPlayer {}

protocol GameAction {}
