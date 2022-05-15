//
//  Mini_TangivelApp.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 12/05/22.
//

import SwiftUI

@main
struct Mini_TangivelApp: App {
    
    var game: ConnectFour
    var player1: ConnectFourPlayer
    var player2: ConnectFourPlayer
    
    init() {
        game = ConnectFour(board_width: 8, board_height: 8)
        player1 = AlphaBetaConnectFourPlayer(game: game)
        player2 = RealConnectFourPlayer(game: game)
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView(gameController: ConnectFourViewModel(game: game, player_1: player1, player_2: player2))
        }
    }
}
