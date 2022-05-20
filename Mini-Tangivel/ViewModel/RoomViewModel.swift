//
//  RoomViewModel.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import Foundation
import Combine
import SwiftUI

class RoomViewModel: ObservableObject {

    @Published private var room: GameRoom?
    @Published var isInsideRoom: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    var code: String { room?.code ?? "Fail" }
    var isOpponentReady: Bool { room?.isOpponentReady ?? false }
    
    func hostGame(playerId: String) {
        FirebaseService.shared.createNewGame(with: playerId)
        FirebaseService.shared.$room
            .assign(to: \.room, on: self)
            .store(in: &cancellables)
        
        if let _ = room {
            isInsideRoom = true
        }
    }
    
    func joinGame(with code: String, playerId: String) {
        FirebaseService.shared.joinGame(with: code, userId: playerId)
        FirebaseService.shared.$room
            .assign(to: \.room, on: self)
            .store(in: &cancellables)
        
        if let _ = room {
            isInsideRoom = true
        }
    }
    
    func leaveRoom(userId: String) {
        guard let _ = room else { return }
        isInsideRoom = false
        FirebaseService.shared.quitGame(with: userId)
    }
    
    func canStartGame() -> Bool {
        guard let room = room else { return false }
        return room.opponentId == nil || room.isOpponentReady
    }
    
    func isHost(_ userId: String) -> Bool {
        guard let room = room else { return false }
        return room.hostId == userId
    }
    
    func toggleOponent() {
        guard room != nil else { return }
        
        room!.isOpponentReady.toggle()
        FirebaseService.shared.updateGame(room!)
    }
}
