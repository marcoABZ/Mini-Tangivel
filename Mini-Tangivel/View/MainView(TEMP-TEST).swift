//
//  MainView(TEMP-TEST).swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var roomViewMode: RoomViewModel = RoomViewModel()
    @State var code: String = ""
    
    // MARK: TEMP - AUX
    let id = UUID()
    
    var body: some View {
        VStack {
            TextField("Code", text: $code)
            Button("Host") {
                roomViewMode.hostGame(playerId: id.uuidString)
            }
            Button("Join") {
                roomViewMode.joinGame(with: code, playerId: id.uuidString)
            }
        }
        .fullScreenCover(isPresented: $roomViewMode.isInsideRoom, onDismiss: {}) {
            RoomView(roomViewModel: roomViewMode, userId: id.uuidString)
        }
    }
    
}

