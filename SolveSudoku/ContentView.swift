//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct Cell
{
    var digit = 0
    var locked = false
}

struct Grid3x3
{
    var cell: [Cell] = [ Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell() ]
    
    mutating func clear()
    {
        for i in 0..<9 {
            cell[ i ].digit = 0
            cell[ i ].locked = false
        }
    }
    
    func allowed( _ val: Int ) -> Bool
    {
        switch val {
        case 0:
            return true
        
        case 1...9:
            for v in cell {
                if val == v.digit {
                    return false
                }
            }
            return true
            
        default: return false
        }
    }
    
    func isLocked( row: Int, col: Int ) -> Bool
    {
        cell[ row * 3 + col ].locked
    }

    mutating func setLocked( row: Int, col: Int, _ abcLocked: Bool )
    {
        cell[ row * 3 + col ].locked = abcLocked
    }

    subscript( row: Int, col: Int ) -> Int
    {
        get {
            assert( row >= 0 && row < 3 && col >= 0 && col < 3, "cell out of range" )
            return cell[ row * 3 + col ].digit
        }
        set {
            assert( newValue >= 0 && newValue <= 9, "value out of range" )
            assert( row >= 0 && row < 3 && col >= 0 && col < 3, "cell out of range" )
            if cell[ row * 3 + col ].digit == newValue {
                cell[ row * 3 + col ].digit = 0
            } else if allowed( newValue ) {
                cell[ row * 3 + col ].digit = newValue
            }
        }
    }
}

struct Game
{
    var grid: [Grid3x3] = [ Grid3x3(), Grid3x3(), Grid3x3(),
                            Grid3x3(), Grid3x3(), Grid3x3(),
                            Grid3x3(), Grid3x3(), Grid3x3() ]

    func allowed( row: Int, col: Int, _ acDigit: Int ) -> Bool
    {
        switch acDigit {
        case 0:
            return true
            
        case 1...9:
            if !grid[ index( row: row, col: col ) ].allowed( acDigit ) {
                return false
            }
            for x in 0..<9 {
                //# Test column
                if acDigit == grid[ index( row: x, col: col ) ][ x % 3, col % 3 ] {
                    return false
                }
                //# Test row
                if acDigit == grid[ index( row: row, col: x ) ][ row % 3, x % 3 ] {
                    return false
                }
            }
            return true
            
        default:
            return false
        }
    }
    
    func isLocked( row: Int, col: Int ) -> Bool
    {
        grid[ index( row: row, col: col ) ].isLocked( row: row % 3, col: col % 3 )
    }
    
    mutating func setLocked( row: Int, col: Int, _ abcLocked: Bool )
    {
        grid[ index( row: row, col: col ) ].setLocked( row: row % 3, col: col % 3, abcLocked )
    }
    
    func index( row: Int, col: Int ) -> Int
    {
        Int( row / 3 ) * 3 + ( col / 3 )
    }
    
    subscript( row: Int, col: Int ) -> Int
    {
        get {
            assert( row >= 0 && row < 9 && col >= 0 && col < 9, "grid out of range" )
            
            return grid[ index( row: row, col: col ) ][ row % 3, col % 3 ]
        }
        set {
            assert( row >= 0 && row < 9 && col >= 0 && col < 9, "grid out of range" )
            
            if grid[ index( row: row, col: col ) ][ row % 3, col % 3 ] == newValue {
                grid[ index( row: row, col: col ) ][ row % 3, col % 3 ] = 0
            } else if allowed( row: row, col: col, newValue ) {
                grid[ index( row: row, col: col ) ][ row % 3, col % 3 ] = newValue
            }
        }
    }
}

struct SmallGrid: View {
    @Binding var enter: Int
    @Binding var grid3x3: Grid3x3
    let clicked: ( Int, Int ) -> Void
    var body: some View {
        VStack {
            ForEach( 0..<3 ) { row in
                HStack {
                    ForEach( 0..<3 ) { col in
                        Button( action: {
                            clicked( row, col )
                        }) {
                            let digit = grid3x3[ row, col ]
                            let locked = grid3x3.isLocked( row: row, col: col )
                            let color = enter != 0 && enter == digit
                                ? Color.green : locked ? Color.red : Color.blue
                            Text( digit == 0 ? "" : String( digit ))
                                .fontWeight(.bold)
                                .font(.title)
                                .frame( width:24, height: 30 )
                                .foregroundColor( color )
                                .padding( 5 )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke( color, lineWidth: 3)
                                )
                        }
                    }
                }
            }
        }
        .padding( 6 )
    }
}

struct EnterButton: View {
    @Binding var enter: Int
    public let digit: Int
    public let action: () -> Void
    var body: some View {
        Button( action: {
            action()
        }) {
            let color = enter != 0 && enter == digit ? Color.green : Color.blue
            Text( String( digit ))
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame( width: 40, height: 40 )
                .foregroundColor( color )
                .padding( 6 )
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke( color, lineWidth: 3 )
                )
        }
    }
}


struct ContentView: View {
    @State private var game = Game()
    @State private var showAlert = false
    @State private var enter = 0
    let sudoku = CSudoku()
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            ForEach( 0..<3 ) { row in
                HStack {
                    ForEach( 0..<3 ) { col in
                        SmallGrid( enter: $enter, grid3x3: $game.grid[ row * 3 + col ] ) { r, c in
                            game[ row * 3 + r, col * 3 + c ] = enter
                            game.setLocked( row: row * 3 + r, col: col * 3 + c,
                                            game[ row * 3 + r, col * 3 + c ] == enter )
                        }
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button( action: {
                    solve()
                }) {
                    Text( "SOLVE" )
                        .padding( 11 )
                        .padding(.horizontal)
                        .background( Color.blue )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                Button( action: {
                    clear()
                }) {
                    Text( "CLEAR" )
                        .padding( 11 )
                        .padding(.horizontal)
                        .background( Color.blue )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            Spacer()
            VStack {
                HStack {
                    ForEach( 0..<5 ) { digit in
                        EnterButton( enter: $enter, digit: digit ) {
                            enter = digit
                        }
                    }
                    .padding( 4 )
                }
                HStack {
                    ForEach( 5..<10 ) { digit in
                        EnterButton( enter: $enter, digit: digit ) {
                            enter = digit
                        }
                    }
                    .padding( 4 )
                }
            }
            Spacer()
        }
        .background(Color.black)
        .alert( isPresented: $showAlert ) {
                 Alert( title: Text( "Sudoku Solver" ),
                        message: Text( "The board could not be solved" ),
                        dismissButton: .default( Text( "OK" )))
             }
    }
    
    func clear()
    {
        for row in 0..<9 {
            for col in 0..<9 {
                game[ row, col ] = 0
                game.setLocked( row: row, col: col, false )
            }
        }
    }
    
    func solve()
    {
        enter = 0
        sudoku.mReset()
        for row in 0..<9 {
            for col in 0..<9 {
                sudoku.mSetCell( row: row + 1, col: col + 1, digit: game[ row, col ] )
                if game[ row, col ] > 0 {
                    game.setLocked( row: row, col: col, true )
                }
            }
        }
        if sudoku.mbSolve() {
            for row in 0..<9 {
                for col in 0..<9 {
                    if game[ row, col ] == 0 {
                        game[ row, col ] = sudoku.mGetCell( row: row + 1, col: col + 1 )
                    }
                }
            }
        }
        else
        {
            showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
