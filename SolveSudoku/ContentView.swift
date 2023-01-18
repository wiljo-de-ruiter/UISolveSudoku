//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct CellView: View {
    @Binding var game: Sudoku
    public let enter: Int
    let row: Int
    let col: Int
    let clicked: () -> Void

    var body: some View {
        Button( action: {
            clicked()
        }) {
            let cell = game[ row: row, col: col ]
            let color = enter != 0 && enter == cell.mDigit
            ? Color.green : cell.mbLocked ? Color.red : Color.gray
            Text( cell.mDigit == 0 ? "" : String( cell.mDigit ))
                .fontWeight( cell.mbLocked ? .semibold : .thin )
                .font(.title2)
                .frame( width:22, height: 22 )
                .foregroundColor( color )
                .padding( 5 )
                .overlay(
                    RoundedRectangle( cornerRadius: 3 )
                        .stroke( color, lineWidth: 2)
                )
        }
    }
}

struct RowView: View {
    @Binding var game: Sudoku
    public let enter: Int
    public let row: Int
    
    var body: some View {
        HStack {
            ForEach( 0..<3 ) { c1 in
                Group {
                    Spacer()
                    ForEach( 0..<3 ) { c2 in
                        let col = c1 * 3 + c2
                        CellView( game: $game, enter: enter, row: row, col: col ) {
                            if enter == game[ row: row, col: col ].mDigit {
                                game.mSetDigit( row: row, col: col, 0 )
                            } else if game.mbAllowed( row: row, col: col, enter ) {
                                game.mLock( row: row, col: col, withDigit: enter )
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct ActionButton: View {
    public let text: String
    public let action: () -> Void
    var body: some View {
        Button( action: {
            action()
        }) {
            Text( text )
                .fontWeight(.semibold)
                .padding( 11 )
                .padding(.horizontal)
                .background( Color.blue )
                .foregroundColor( .white )
                .cornerRadius( 7 )
        }
    }
}

struct ActionBar: View {
    @Binding var game: Sudoku
    @Binding var enter: Int
    @State private var showAlert = false
    
    var body: some View {
        HStack {
            Spacer()
            ActionButton( text: "SOLVE " ) {
                enter = 0
                if !game.mbSolve() {
                    showAlert = true
                }
            }
            .disabled( !game.mbHasDigits(count: 5))
            Spacer()
            ActionButton( text: "CLEAR" ) {
                game.mReset()
            }
            Spacer()
        }
        .alert( isPresented: $showAlert ) {
                 Alert( title: Text( "Sudoku Solver" ),
                        message: Text( "The board could not be solved" ),
                        dismissButton: .default( Text( "OK" )))
             }
    }
}

struct EnterButton: View {
    @Binding var enter: Int
    public let digit: Int
    
    var body: some View {
        Button( action: {
            enter = digit
        }) {
            let color = enter != 0 && enter == digit ? Color.green : Color.gray
            Text( String( digit ))
                .fontWeight(.heavy)
                .font(.largeTitle)
                .frame( width: 36, height: 36 )
                .foregroundColor( color )
                .padding( 6 )
                .overlay(
                    RoundedRectangle( cornerRadius: 5 )
                        .stroke( color, lineWidth: 3 )
                )
        }
    }
}

struct EnterBar: View {
    @Binding var enter: Int
    
    var body: some View {
        VStack {
            HStack {
                ForEach( 0..<5 ) { digit in
                    EnterButton( enter: $enter, digit: digit )
                }
                .padding( 5 )
            }
            HStack {
                ForEach( 5..<10 ) { digit in
                    EnterButton( enter: $enter, digit: digit )
                }
                .padding( 5 )
            }
        }
    }
}

struct ContentView: View {
    @State private var game = Sudoku()
    @State private var enter = 0
    
    var body: some View {
        VStack {
            Text( "Sudoku Solver" )
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text( "Enter digits and solve the puzzle" )
                .font(.caption)
                .foregroundColor(.gray)
            ForEach( 0..<9 ) { row in
                if row % 3 == 0 {
                    Spacer()
                }
                RowView( game: $game, enter: enter, row: row )
            }
            Spacer()
            ActionBar( game: $game, enter: $enter )
            Spacer()
            EnterBar( enter: $enter )
            Spacer()
            Text( "(c) 2023 W.J. de Ruiter" )
                .font(.body)
                .foregroundColor(.gray)
        }
        .background(Color.black)
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
