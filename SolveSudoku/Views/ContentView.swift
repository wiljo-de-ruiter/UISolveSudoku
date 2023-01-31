//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct ContentView: View {
    @State private var game = Sudoku()
    @State private var enter = 0
    
    var body: some View {
        VStack {
            Group {
                Text( "Sudoku Solver" )
                    .font(.largeTitle)
                    .foregroundColor(Color.normalTextColor)
                Text( "Enter digits and solve the puzzle" )
                    .font(.caption)
                    .foregroundColor(Color.normalTextColor)
                Spacer()
            }
            SudokuView( game: $game, enter: enter )
            Spacer()
            Group {
                Spacer()
                ActionBar( game: $game, enter: $enter )
                Spacer()
                EnterBar( enter: $enter )
                Spacer()
            }
//            Group {
//                HStack {
//                    Image( systemName: "c.circle" )
//                    Text( "2023 W.J. de Ruiter" )
//                }
//                .font(.body)
//                .foregroundColor(.gray)
//            }
        }
        .background(Color.normalBackColor)
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
