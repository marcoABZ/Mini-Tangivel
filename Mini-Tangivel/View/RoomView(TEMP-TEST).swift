//
//  RoomView.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import SwiftUI

struct RoomView: View {
    
    @ObservedObject var roomViewModel: RoomViewModel
    let userId: String
    
    var body: some View {
        VStack {
            Text(roomViewModel.code)
            Button("Leave room") { roomViewModel.leaveRoom(userId: userId) }
            if roomViewModel.isHost(userId) {
                Button("Start Game") {
                    print("Começou jogo")
                }.disabled(!roomViewModel.canStartGame())
            } else {
                Button(roomViewModel.isOpponentReady ? "I'm not ready" : "I'm ready!") {
                    roomViewModel.toggleOponent()
                }
            }
        }
    }
}
