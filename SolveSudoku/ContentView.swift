//
//  ContentView.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

enum GameState
{
    case Edit
    case Solve
}

struct Grid3x3
{
    var cell: [Int] = [ -1, -1, -1, -1, -1, -1, -1, -1, -1 ]
    
    func allowed( row: Int, col: Int, _ val: Int ) -> Bool
    {
        for v in cell {
            if val == v {
                return false
            }
        }
        return true
    }
    
    subscript( row: Int, col: Int ) -> Int
    {
        get {
            assert( row >= 0 && row < 3 && col >= 0 && col < 3, "cell out of range" )
            return cell[ 3 * row + col ]
        }
        set {
            assert( row >= 0 && row < 3 && col >= 0 && col < 3, "cell out of range" )
            if cell[ row * 3 + col ] == newValue {
                cell[ row * 3 + col ] = -1
            } else if allowed( row: row, col: col, newValue ) {
                cell[ row * 3 + col ] = newValue
            }
        }
    }
}

struct Game
{
    var grid: [Grid3x3] = [ Grid3x3(), Grid3x3(), Grid3x3(),
                            Grid3x3(), Grid3x3(), Grid3x3(),
                            Grid3x3(), Grid3x3(), Grid3x3() ]

    func allowed( row: Int, col: Int, _ val: Int ) -> Bool
    {
        if !grid[ index( row: row, col: col ) ].allowed(row: row % 3, col: col % 3, val ) {
            return false
        }
        for x in 0..<9 {
            //# Test column
            if grid[ index( row: x, col: col ) ][ x % 3, col % 3 ] == val {
                return false
            }
            //# Test row
            if grid[ index( row: row, col: x ) ][ row % 3, x % 3 ] == val {
                return false
            }
        }
        return true
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
                grid[ index( row: row, col: col ) ][ row % 3, col % 3 ] = -1
            } else if allowed( row: row, col: col, newValue ) {
                grid[ index( row: row, col: col ) ][ row % 3, col % 3 ] = newValue
            }
        }
    }

}

struct SmallGrid: View {
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
                            let v = grid3x3[ row, col ]
                            switch v {
                            case 0...9: Image( systemName: "\(v).square")
                            default:    Image( systemName: "square.and.pencil")
                            }
                        }
                        .font( .title3 )
                    }
                }
            }
        }
        .padding()
    }
}

struct EnterButton: View {
    public let selected: Bool
    public let systemImage: String
    public let action: () -> Void
    var body: some View {
        Button( action: {
            action()
        }) {
            Image( systemName: systemImage )
        }
        .foregroundColor( selected ? .red : .blue )
        .font( .title2 )
    }
}


struct ContentView: View {
    @State private var game = Game()
    @State private var gameState = GameState.Edit
    @State private var enter = 0
    
    var body: some View {
        VStack {
            Spacer()
            ForEach( 0..<3 ) { row in
                HStack {
                    ForEach( 0..<3 ) { col in
                        SmallGrid( grid3x3: $game.grid[ row * 3 + col ] ) { r, c in
                            game[ row * 3 + r, col * 3 + c ] = enter
                        }
                    }
                }
            }
            Spacer()
            HStack {
                ForEach( 0..<10 ) { digit in
                    EnterButton( selected: enter == digit, systemImage: "\(digit).square" ) {
                        enter = digit
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
