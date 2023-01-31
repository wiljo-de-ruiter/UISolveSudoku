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

//struct ActionBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ActionBar()
//    }
//}
