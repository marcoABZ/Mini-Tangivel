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
        VStack {
            ConnectFourGridView(gameViewModel: gameViewModel)
            Button("Start game") { withAnimation { gameViewModel.startGame() } }
        }
    }
    
}
