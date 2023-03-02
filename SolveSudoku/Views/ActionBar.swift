//
//  ActionBar.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-27.
//

import SwiftUI

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
    public let text: String
    @Binding var working: Bool
    public let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text( text )
                .fontWeight(.semibold)
                .padding( 11 )
                .padding(.horizontal)
                .background( working ? Color.lightLineColor : Color.blue )
                .foregroundColor( working ? Color.lightLineColor : Color.white )
                .cornerRadius( 7 )
                .overlay {
                    if working {
                        ProgressView()
                    }
                }
        }
    }
}

struct ActionBar: View {
    @Binding var game: Sudoku
    @Binding var working: Bool
    @Binding var enter: Int
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Spacer()
  
            WorkButton( text: "SOLVE", working: $working ) {
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
//                EmailHelper.shared.sendEmail( subject: "Anything...", body: "Whatever", to: "wiljo.de.ruiter@gmail.com")
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

    public func solvePuzzle() async
    {
        enter = 0
        working = true
        sleep(1)
        var helper = game
        if helper.mbSolve() {
            for row in 0..<9 {
                for col in 0..<9 {
                    guard game[ row: row, col: col ].mbIsEmpty() else { continue }
                    try? await Task.sleep( nanoseconds: 40_000_000 )
                    game[ row: row, col: col ].mSetDigit( helper[ row: row, col: col ].mDigit )
                }
            }
        } else {
            showAlert = true
        }
        working = false
    }
}
