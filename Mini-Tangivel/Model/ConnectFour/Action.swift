//
//  ConnectFourAction.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 13/05/22.
//

import Foundation

struct ConnectFourAction: GameAction, Equatable {
    var player: Int?
    let column: Int
}
