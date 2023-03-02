//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct ContentView: View {
    @State private var game = Sudoku()
    @State private var isWorking = false
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
            }
            Group {
                Spacer()
                SudokuView( game: $game, enter: enter )
                    .disabled( isWorking )
                Spacer()
            }
            Group {
                HStack {
                    Spacer()
                    ActionBar( game: $game, working: $isWorking, enter: $enter )
                    Spacer()
                    EnterGrid( enter: $enter )
                    Spacer()
                }
                .disabled( isWorking )
                .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
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
