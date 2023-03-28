//
//  ActionBar.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-27.
//

import SwiftUI

var bodyMail: String = ""

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

struct WorkButton: View {
    @EnvironmentObject var global: CGlobalData
    @EnvironmentObject var game: CSudoku
    public let text: String
    public let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text( text )
                .fontWeight(.semibold)
                .padding( 11 )
                .padding(.horizontal)
                .background( global.mbWorking ? Color.lightLineColor : Color.blue )
                .foregroundColor( global.mbWorking ? Color.lightLineColor : Color.white )
                .cornerRadius( 7 )
                .overlay {
                    if global.mbWorking {
                        ProgressView()
                    }
                }
        }
    }
}

struct ActionBar: View {
    @EnvironmentObject var global: CGlobalData
    @EnvironmentObject var game: CSudoku
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Spacer()
  
            WorkButton( text: "SOLVE" ) {
                Task {
                    await solvePuzzle()
                }
            }
            .disabled( !game.mbHasDigits(count: 5))
            
            Spacer()

            ActionButton( text: "CLEAR" ) {
                if !game.mbClearNotLocked() {
                    game.mClearAll()
                }
            }
//            Spacer()
//            ActionButton( text: "Send Email" ) {
//                EmailHelper.shared.sendEmail( subject: "Solved sudoku puzzle", body: bodyMail, to: "wiljo.de.ruiter@gmail.com")
//            }
            Spacer()
            Group {
                HStack {
                    Image( systemName: "c.circle" )
                    Text( "2023" )
                }
                Text( "W.J. de Ruiter" )
            }
            .font(.caption)
            .foregroundColor(Color.lightLineColor)
        }
        .alert( isPresented: $showAlert ) {
                 Alert( title: Text( "Sudoku Solver" ),
                        message: Text( "The board could not be solved" ),
                        dismissButton: .default( Text( "OK" )))
             }
    }
    //------------------------------------------------------------------------
    public func solvePuzzle() async
    {
        global.mEnter = 0
        global.mbWorking = true
        try? await Task.sleep( nanoseconds: 1_000_000_000 )
        let helper = CSudoku()
        helper.mAssign( game: game )
        
        if helper.mbSolve() {
            bodyMail = "Initial puzzle:<br>"
            bodyMail += game.mBoard()
            for row in 0..<9 {
                for col in 0..<9 {
                    guard game[ row: row, col: col ].mbIsEmpty() else { continue }
                    try? await Task.sleep( nanoseconds: 40_000_000 )
                    game[ row: row, col: col ].mSetDigit( helper[ row: row, col: col ].mDigit )
                }
            }
            bodyMail += game.mBoard( solution: true )
        } else {
            showAlert = true
        }
        global.mbWorking = false
    }
}
