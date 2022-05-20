//
//  ConnectFourCellView.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 15/05/22.
//

import SwiftUI

struct ConnectFourCellView: View {
    
    var value: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 40, height: 40)
        Circle()
            .fill(value == 0 ? Color.white : value == 1 ? Color.red : Color.blue)
            .frame(width: 36, height: 36)
    }
}
