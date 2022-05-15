//
//  AlphaBetaPlayer.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 12/05/22.
//

import Foundation


struct AlphaBetaPlayer<G: GameProtocol> {
    
    private var game: G
    private var transposition_table: [AnyHashable: Double]
    private var time_limit: TimeInterval
    private var heuristic: ((G.State) -> Double)
    private var alpha: Double = Double.infinity
    private var beta: Double = -Double.infinity
    private var start_time: Date = Date.now
    private var halt: Bool = false
    private var depth_limit: Double = 1
    
    init(game: G, time_limit: TimeInterval = 1, heuristic: @escaping (G.State) -> Double) {
        self.game = game
        self.time_limit = time_limit
        self.heuristic = heuristic
        self.transposition_table = [:]
    }
    
    
    mutating func getAction(at state: G.State) -> G.Action {
        let action = alphaBetaDecision(state)
        return action
    }

    mutating private func alphaBetaDecision(_ state: G.State) -> G.Action {
        alpha = Double.infinity
        beta = -Double.infinity
        start_time = Date.now
        halt = false
        depth_limit = 1
        
        var possible_actions = game.getPossibleActions(at: state)
        
        while true {
            let time_dif = start_time.distance(to: Date.now)
            if (time_dif > time_limit) {
                return possible_actions.first!
            }
            
            let values = possible_actions.map { minValue(state: game.perform(action: $0, at: state), depth: 0.5) }
            let joined = zip(possible_actions, values)
            
            if (!halt) {
                let sorted_actions = joined.sorted(by: { $0.1 > $1.1 })
                possible_actions = sorted_actions.map({ $0.0 })
                depth_limit += 1
            }
        }
    }
    
    mutating private func maxValue(state: G.State, depth: Double) -> Double {
        if cutoffTest(state: state, depth: depth) {
            if let stored_evaluation = transposition_table[state.hashableRepresentation] {
                return stored_evaluation
            }
            
            let evaluation = heuristic(state)
            transposition_table[state.hashableRepresentation] = evaluation
            return evaluation
        }
        
        var value = -Double.infinity
        let actions = game.getPossibleActions(at: state)
        
        for action in actions {
            let action_value = minValue(state: game.perform(action: action, at: state), depth: depth + 0.5)
            value = max(action_value, value)
            
            if value >= beta {
                return value
            }
            
            alpha = max(alpha, value)
        }
        return value
    }
    
    mutating private func minValue(state: G.State, depth: Double) -> Double {
        if cutoffTest(state: state, depth: depth) {
            if let stored_evaluation = transposition_table[state.hashableRepresentation] {
                return stored_evaluation
            }
            
            let evaluation = heuristic(state)
            transposition_table[state.hashableRepresentation] = evaluation
            return evaluation
        }
        
        var value = Double.infinity
        let actions = game.getPossibleActions(at: state)
        
        for action in actions {
            let action_value = maxValue(state: game.perform(action: action, at: state), depth: depth + 0.5)
            value = min(action_value, value)
            
            if value <= alpha {
                return value
            }
            
            beta = min(beta, value)
        }
        return value
        
    }
    
    mutating private func cutoffTest(state: G.State, depth: Double) -> Bool {
        if (Date.now.distance(to: start_time) > time_limit) { halt = true }
        return depth >= depth_limit || game.isGameOver(state: state) || Date.now.distance(to: start_time) > time_limit
    }
    
}
