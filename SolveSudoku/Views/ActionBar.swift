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
    public let action: () -> Void
    @State private var isWorking = false
    
    var body: some View {
        Button {
            Task {
                await execAction()
            }
        } label: {
            Text( text )
                .fontWeight(.semibold)
                .padding( 11 )
                .padding(.horizontal)
                .background( isWorking ? Color.lightLineColor : Color.blue )
                .foregroundColor( .white )
                .cornerRadius( 7 )
                .opacity( isWorking ? 0 : 1 )
                .overlay {
                    if isWorking {
                        ProgressView()
                    }
                }
        }
        .disabled(isWorking)
    }
    
    public func execAction() async
    {
        isWorking = true
        action()
        isWorking = false
    }
}

struct ActionBar: View {
    @Binding var game: Sudoku
    @Binding var enter: Int
    @State private var showAlert = false
    
    var body: some View {
        HStack {
            Spacer()
            WorkButton( text: "SOLVE" ) {
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
