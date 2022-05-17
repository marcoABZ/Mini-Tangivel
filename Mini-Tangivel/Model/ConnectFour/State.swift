//
//  ConnectFourGameState.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 13/05/22.
//

import Foundation

struct ConnectFourState: GameState, Hashable {
    var hashableRepresentation: AnyHashable { self.grid }
    private(set) var grid: [[Int]]
    private(set) var move_count: Int = 0
    
    private var grid_width: Int { grid[0].count }
    var is_over: Bool {
        for i in 0..<grid.count {
            for j in 0..<grid_width {
                let origin = [i,j]
                let mask = [
                    [[origin[0] - 3, origin[1] - 3], [origin[0] - 2, origin[1] - 2], [origin[0] - 1, origin[1] - 1], origin],
                    [[origin[0] - 3, origin[1] - 0], [origin[0] - 2, origin[1] - 0], [origin[0] - 1, origin[1] - 0], origin],
                    [[origin[0] - 3, origin[1] + 3], [origin[0] - 2, origin[1] + 2], [origin[0] - 1, origin[1] + 1], origin],
                    [[origin[0] - 0, origin[1] + 3], [origin[0] - 0, origin[1] + 2], [origin[0] - 0, origin[1] + 1], origin],
                    [[origin[0] + 3, origin[1] + 3], [origin[0] + 2, origin[1] + 2], [origin[0] + 1, origin[1] + 1], origin],
                    [[origin[0] + 3, origin[1] - 0], [origin[0] + 2, origin[1] - 0], [origin[0] + 1, origin[1] - 0], origin],
                    [[origin[0] - 3, origin[1] + 3], [origin[0] - 2, origin[1] + 2], [origin[0] - 1, origin[1] + 1], origin],
                    [[origin[0] - 0, origin[1] - 3], [origin[0] - 0, origin[1] - 2], [origin[0] - 0, origin[1] - 1], origin]]
                let filtered_mask = mask.filter {
                                        $0.allSatisfy {
                                            $0[0] >= 0 && $0[0] < grid.count && $0[1] >= 0 && $0[1] < grid_width
                                        }
                                    }
                let filtered_positions = filtered_mask.map { $0.map { grid[$0[0]][$0[1]] } }.filter { $0.allSatisfy { $0 != 0 } && Set($0).count == 1 }
                if !filtered_positions.isEmpty { return true }
            }
        }
        return false
    }
    
    var winner: Int? {
        if !self.is_over { return nil }
        return move_count % 2 == 0 ? -1 : 1
    }
    
    init(width: Int, height: Int) {
        self.grid = []
        for _ in 0..<height {
            grid.append(Array.init(repeating: 0, count: width))
        }
    }
    
    func getNotFilledRowsIndexes() -> [Int] {
        return Array(0 ..< grid_width).filter { grid[0][$0] == 0 }
    }
    
    func dropPiece(at row: Int) -> ConnectFourState {
        var copy = self
        let player = move_count % 2 == 0 ? 1 : -1
        
        for i in Array(0..<grid.count).reversed() {
            if copy.grid[i][row] == 0 {
                copy.grid[i][row] = player
                copy.move_count += 1
                return copy
            }
        }
        return copy
    }
}
