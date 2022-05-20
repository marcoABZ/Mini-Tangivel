//
//  FirebaseService.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class FirebaseService: ObservableObject {
    
    static let shared = FirebaseService()
    @Published var room: GameRoom!
    
    init() {}
    
    private func createOnlineGame(with userId: String) {
        // Save the game online
        let options = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let roomCode = String((0..<6).map { _ in options.randomElement()! })
        self.room = GameRoom(code: roomCode, hostId: userId)
        
        do {
            try firebaseReference(.game)
                .document(self.room.code)
                .setData(from: self.room)
        } catch {
            print("Error creating online game", error.localizedDescription)
        }
    }
    
    func joinGame(with code: String, userId: String) {
        firebaseReference(.game)
            .whereField("code", isEqualTo: code)
            .getDocuments { querySnapshot, error in
                if let _ = error {
                    return
                }
                
                if let gameData = querySnapshot?.documents.first {
                    self.room = try? gameData.data(as: GameRoom.self)
                    self.room.opponentId = userId
                    
                    self.updateGame(self.room)
                    self.listenForGameChanges()
                }
            }
    }
    
//    func startGame(with userId: String) {
//        // Check if there is a game to join, if no, we create new game. If yes, we will join and start listening for any changes in the game.
//        firebaseReference(.game)
//            .whereField("player2Id", isEqualTo: "")
//            .whereField("player1Id", isNotEqualTo: userId)
//            .getDocuments { querySnapshot, error in
//
//                if let error = error {
//                    print("Error starting game", error.localizedDescription)
//                    self.createNewGame(with: userId)
//                    return
//                }
//
//                if let gameData = querySnapshot?.documents.first {
//                    self.room = try? gameData.data(as: GameRoom.self)
//                    self.room.opponentId = userId
//
//                    self.updateGame(self.room)
//                    self.listenForGameChanges()
//                    return
//                }
//
//                self.createNewGame(with: userId)
//            }
//    }
    
    private func listenForGameChanges() {
        firebaseReference(.game).document(self.room.code).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let snapshot = documentSnapshot {
                self.room = try? snapshot.data(as: GameRoom.self)
            }
        }
    }
    
    func createNewGame(with userId: String) {
        // Create new game object
        self.createOnlineGame(with: userId)
        self.listenForGameChanges()
    }
    
    func updateGame(_ game: GameRoom) {
        do {
            try firebaseReference(.game).document(game.code).setData(from: game)
        } catch {
            print("Error updating online game", error.localizedDescription)
        }
    }
    
    func quitGame(with userId: String) {
        guard self.room != nil else { return }
        
        if room.hostId == userId {
            // Pass host to other player
            if let opponentId = room.opponentId {
                room.hostId = opponentId
                room.opponentId = nil
                updateGame(room)
                return
            }
            
            // No players left, remove room
            firebaseReference(.game).document(self.room.code).delete()
            return
        }
        
        // Oponent left the room
        room.opponentId = nil
        updateGame(room)
        return
    }
}
