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
    private var alpha: Double = -Double.infinity
    private var beta: Double = Double.infinity
    private var start_time: Date = Date.now
    private var halt: Bool = false
    private var depth_limit: Double = 1
    
    init(game: G, time_limit: TimeInterval = 1, heuristic: @escaping (G.State) -> Double) {
        self.game = game
        self.time_limit = time_limit
        self.heuristic = heuristic
        self.transposition_table = [:]
    }
    
    mutating func selectAction(at state: G.State, from possible_actions: [G.Action]) -> G.Action {
        return alphaBetaDecision(state, possible_actions)
    }

    mutating private func alphaBetaDecision(_ state: G.State, _ possible_actions: [G.Action]) -> G.Action {
        alpha = -Double.infinity
        beta = Double.infinity
        start_time = Date.now
        halt = false
        depth_limit = 1
        
        var sorted_actions = possible_actions
        
        while true {
            if halt {
                print("Depth \(depth_limit)")
                return sorted_actions.first!
            }
            
            let state_copy = state
            let values = sorted_actions.map { minValue(state: game.perform(action: $0, at: state_copy), depth: 0.5) }
            let joined = zip(sorted_actions, values)
            
            if (!halt) {
                let sorted_actions_values = joined.sorted(by: { $0.1 > $1.1 })
                sorted_actions = sorted_actions_values.map({ $0.0 })
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
        let state_copy = state
        let actions = game.getPossibleActions(at: state_copy)
        
        for action in actions {
            let action_value = minValue(state: game.perform(action: action, at: state_copy), depth: depth + 0.5)
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
        let state_copy = state
        let actions = game.getPossibleActions(at: state_copy)
        
        for action in actions {
            let action_value = maxValue(state: game.perform(action: action, at: state_copy), depth: depth + 0.5)
            value = min(action_value, value)
            
            if value <= alpha {
                return value
            }
            
            beta = min(beta, value)
        }
        return value
        
    }
    
    mutating private func cutoffTest(state: G.State, depth: Double) -> Bool {
        if (start_time.distance(to: Date.now) > time_limit) { halt = true }
        return depth >= depth_limit || game.isGameOver(state: state) || halt
    }
    
}
