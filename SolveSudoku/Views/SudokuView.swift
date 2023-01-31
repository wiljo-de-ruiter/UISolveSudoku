//
//  SudokuView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-27.
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
            let selected = enter != 0 && enter == cell.mDigit
            let backColor = selected ? Color.selectedBackColor :
                cell.mbLocked ? Color.lockedBackColor: Color.normalBackColor
            Rectangle()
                .stroke( Color.lightLineColor, lineWidth: 1 )
                .background( backColor )
                .aspectRatio(contentMode: .fit)
                .overlay() {
                    Text( cell.mDigit == 0 ? "" : String( cell.mDigit ))
                        .fontWeight( cell.mbLocked ? .bold : .thin )
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
                                    } else if game.mbIsAllowed( row: rr, col: cc, UInt8( enter )) {
                                        game.mLockDigit( row: rr, col: cc, UInt8( enter ))
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

//struct SudokuView_Previews: PreviewProvider {
//    static var previews: some View {
//        SudokuView()
//    }
//}
