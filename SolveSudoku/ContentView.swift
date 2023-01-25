//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

extension Color {
    static var normalTextColor = Color( "NormalTextColor" )
    static var lockedBackColor = Color( "LockedBackColor" )
    static var normalBackColor = Color( "NormalBackColor" )
    static var selectedBackColor = Color( "SelectedBackColor" )
    static var heavyLineColor = Color( "HeavyLineColor" )
    static var lightLineColor = Color( "LightLineColor" )
}

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
            let selected = enter != 0 && enter == cell.mDigit
            let backColor = selected ? Color.selectedBackColor :
                cell.mbLocked ? Color.lockedBackColor: Color.normalBackColor
            Rectangle()
                .stroke( Color.lightLineColor, lineWidth: 1 )
                .background( backColor )
                .aspectRatio(contentMode: .fit)
                .overlay() {
                    Text( cell.mDigit == 0 ? "" : String( cell.mDigit ))
                        .fontWeight( cell.mbLocked ? .heavy : .light )
                        .font( .title )
                        .foregroundColor( Color.normalTextColor )
                }
        }
    }
}

struct SquareView: View {
    @Binding var game: Sudoku
    public let enter: Int
    public let row: Int
    public let col: Int

    var body: some View {
        Rectangle()
            .stroke( Color.heavyLineColor, lineWidth: 3 )
            .background( Color.normalBackColor )
            .aspectRatio( contentMode: .fit )
            .overlay() {
                VStack( spacing: 0 ) {
                    ForEach( 0..<3 ) { r in
                        let rr = row + r
                        HStack( spacing: 0 ) {
                            ForEach( 0..<3 ) { c in
                                let cc = col + c
                                CellView( game: $game, enter: enter, row: rr, col: cc ) {
                                    if enter == game[ row: rr, col: cc ].mDigit {
                                        game.mSetDigit( row: rr, col: cc, 0 )
                                    } else if game.mbAllowed( row: rr, col: cc, UInt8( enter )) {
                                        game.mLock( row: rr, col: cc, withDigit: UInt8( enter ))
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
}

struct SudokuView: View {
    @Binding var game: Sudoku
    public let enter: Int

    var body: some View {
        VStack( spacing: 2 ) {
            ForEach( 0..<3 ) { rr in
                HStack( spacing: 2 ) {
                    Spacer()
                    ForEach( 0..<3 ) { cc in
                        SquareView(game: $game, enter: enter, row: rr * 3, col: cc * 3 )
                    }
                    Spacer()
                }
            }
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
                var helper = game
                if helper.mbSolve() {
                    game = helper
                } else {
                    showAlert = true
                }
            }
            .disabled( !game.mbHasDigits(count: 5))
            Spacer()
            ActionButton( text: "CLEAR" ) {
                if !game.mbClearNotLocked() {
                    game.mClearAll()
                }
            }
            Spacer()
//            ActionButton( text: "Send Email" ) {
//                EmailHelper.shared.sendEmail( subject: "Anything...", body: "Whatever", to: "wiljo.de.ruiter@gmail.com")
//            }
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
            let selected = enter != 0 && digit == enter
            let backColor = selected ? Color.selectedBackColor : Color.lightLineColor
            RoundedRectangle( cornerRadius: 7 )
                .fill( backColor )
                .aspectRatio(CGFloat(0.7), contentMode: .fit)// contentMode: .fill )
                .overlay() {
                    Text( "\(digit)" )
                        .fontWeight( selected ? .heavy : .light )
                        .font( .title )
                        .foregroundColor( Color.normalTextColor )
                }
        }
    }
}

struct EnterBar: View {
    @Binding var enter: Int
    
    var body: some View {
        HStack( spacing: 2 ) {
            Spacer()
            ForEach( 1..<10 ) { digit in
                EnterButton( enter: $enter, digit: digit )
            }
            Spacer()
        }
    }
}

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
            }
            Group {
                Spacer()
                HStack {
                    Image( systemName: "c.circle" )
                    Text( "2023 W.J. de Ruiter" )
                }
                .font(.body)
                .foregroundColor(.gray)
            }
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
