//
//  ConnectFourGridView.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import SwiftUI

struct ConnectFourGridView: View {
    
    @ObservedObject var gameViewModel: ConnectFourViewModel

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameViewModel.currentGameState.grid.count) { i in
                HStack(spacing: 0) {
                    ForEach(0..<gameViewModel.currentGameState.grid[i].count) { j in
                        ZStack {
                            ConnectFourCellView(value: gameViewModel.currentGameState.grid[i][j])
                                .onTapGesture { withAnimation { gameViewModel.check(action: ConnectFourAction(column: j)) } }
                        }
                    }
                }
            }
        }
    }
}
