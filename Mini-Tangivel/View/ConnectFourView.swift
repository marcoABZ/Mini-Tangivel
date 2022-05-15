//
//  ConnectFourView.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import SwiftUI

struct ConnectFourView: View {
    
    @ObservedObject var gameViewModel: ConnectFourViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameViewModel.currentGameState.grid.count) { i in
                HStack(spacing: 0) {
                    ForEach(0..<gameViewModel.currentGameState.grid[i].count) { j in
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 40, height: 40)
                            Circle()
                                .fill(gameViewModel.currentGameState.grid[i][j] == 0 ? Color.white : gameViewModel.currentGameState.grid[i][j] == 1 ? Color.red : Color.blue)
                                .frame(width: 36, height: 36)
                        }.onTapGesture {
                            withAnimation { gameViewModel.perform(action: ConnectFourAction(column: j))
                            }
                        }
                    }
                }
            }
        }
    }
    
}
