//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var global = CGlobalData()
    @StateObject private var game = CSudoku()
    
    var body: some View {
        VStack {
            Group {
                Text( "Sudoku Solver" )
                    .font(.largeTitle)
                    .foregroundColor(Color.normalTextColor)
                Text( "Enter digits and solve the puzzle" )
                    .font(.caption2)
                    .foregroundColor(Color.normalTextColor)
            }
            Group {
                Spacer()
                SudokuView()
                    .disabled( global.mbWorking )
                Spacer()
            }
            Group {
                HStack {
                    Spacer()
                    ActionBar()
                    Spacer()
                    EnterGrid()
                    Spacer()
                }
                .disabled( global.mbWorking )
                .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .environmentObject( game )
        .environmentObject( global )
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
