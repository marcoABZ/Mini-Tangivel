//
//  Mini_TangivelApp.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 12/05/22.
//

import SwiftUI
import Firebase

@main
struct Mini_TangivelApp: App {
    
    var game: ConnectFour
    var player1: ConnectFourPlayer
    var player2: ConnectFourPlayer
    
    init() {
        FirebaseApp.configure()
        game = ConnectFour(board_width: 8, board_height: 8)
        player2 = AlphaBetaConnectFourPlayer(game: game)
        player1 = RealConnectFourPlayer(game: game)
    }

    
    var body: some Scene {
        WindowGroup {
            MainView()
//            ContentView(gameController: ConnectFourViewModel(game: game, player_1: player1, player_2: player2))
        }
    }
}
