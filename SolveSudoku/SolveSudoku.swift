//
//  main.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 23/01/2021.
//

import Foundation
//----------------------------------------------------------------------------
public func SquareRange( index aIndex: Int ) -> Range<Int>
{
    let start = aIndex - ( aIndex - 1 ) % 3
    return start ..< start + 3
}
//#
//############################################################################
//# CSudoku
//#
class CSudoku
{
    public init()
    {
        m_Nested = 0
        m_Board = CBoard()
    }
    //------------------------------------------------------------------------
    public convenience init(_ aSudoku: CSudoku )
    {
        self.init()
        mAssign( aSudoku )
        m_Nested += 1
    }
    //------------------------------------------------------------------------
    public func mbSolve() -> Bool
    {
        var bNotSolved = false
        var bSingles = false
        repeat {
            var bestRating = 9
            var bestRow = 0
            var bestCol = 0
            bNotSolved = false
            bSingles = false
            for row in 1..<10 {
                for col in 1..<10 {
                    guard m_Board[ row, col ].mbIsEmpty() else { continue }
                    var digitCount = 0
                    var bestDigit = 0
                    for digit in 1..<10 {
                        if m_Board[ row, col ].mbAllowed(digit: digit) {
                            digitCount += 1
                            bestDigit = digit
                        }
                    }
                    switch digitCount {
                    case 0:
                        return false
                        
                    case 1:
                        mSetCell(row: row, col: col, digit: bestDigit)
                        bSingles = true
                        
                    default:
                        for digit in 1..<10 {
                            if m_Board[ row, col ].mbAllowed(digit: digit) {
                                let rating = m_ComputeRating(row: row, col: col, digit: digit)
                                if rating == 1 {
                                    mSetCell(row: row, col: col, digit: digit)
                                    bSingles = true
                                } else if rating < bestRating {
                                    bNotSolved = true
                                    bestRating = rating
                                    bestRow = row
                                    bestCol = col
                                }
                            }
                        }
                    }
                }
            }
            if !bSingles && bestRow > 0 && bestCol > 0 {
                for digit in 1..<10 {
                    if m_Board[ bestRow, bestCol ].mbAllowed(digit: digit) {
                        let helper = CSudoku( self )
                        print("Try \(digit) at \(bestRow) x \(bestCol)")
                        helper.mSetCell(row: bestRow, col: bestCol, digit: digit)
                        if helper.mbSolve() {
                            mAssign( helper )
                            return true
                        }
                        print("Rejected \(digit) at \(bestRow) x \(bestCol)")
                    }
                }
                return false
            }
        } while bNotSolved
        return true
    }
    //------------------------------------------------------------------------
    public func mAssign(_ aSudoku: CSudoku )
    {
        m_Nested = aSudoku.m_Nested
        m_Board = aSudoku.m_Board
    }
    //------------------------------------------------------------------------
    public func mSetRow( row aRow: Int, digits aDigits: String )
    {
        var col = 1
        for char in aDigits {
            if let digit = char.wholeNumberValue {
                mSetCell( row: aRow, col: col, digit: digit )
                col += 1
            } else if char == "." {
                col += 1
            }
        }
    }
    //------------------------------------------------------------------------
    public func mReset()
    {
        m_Nested = 0
        for row in 0..<10 {
            for col in 0..<10 {
                m_Board[ row, col ].mReset()
            }
        }
    }
    //------------------------------------------------------------------------
    public func mShowBoard()
    {
        for row in 1..<10 {
            var line = ""
            if row == 4 || row == 7 { print("") }
            for col in 1..<10 {
                if col == 4 || col == 7 { line += "  " }
                line.append( m_Board[ row, col ].mCharDigit )
                line.append( " " )
            }
            print( line )
        }
        print( "" )
    }
    //------------------------------------------------------------------------
    public func mShowSolution()
    {
        print("Solution:")
        mShowBoard()
        print("Max nested: \(m_Nested)")
    }
    //------------------------------------------------------------------------
    public func mSetCell( row aRow: Int, col aCol: Int, digit aDigit: Int )
    {
        guard 1..<10 ~= aDigit else { return }
        m_Board[ aRow, aCol ].mSetDigit( digit: aDigit )
        m_ClearRow( row: aRow, digit: aDigit )
        m_ClearCol( col: aCol, digit: aDigit )
        m_ClearSquare( row: aRow, col: aCol, digit: aDigit )
    }
    //------------------------------------------------------------------------
    public func mGetCell( row aRow: Int, col aCol: Int ) -> Int
    {
        m_Board[ aRow, aCol ].mDigit
    }
    //------------------------------------------------------------------------
    private func m_ClearRow( row aRow: Int, digit aDigit: Int )
    {
        for col in 1..<10 {
            m_Board[ aRow, col ].mClearAllowed( digit: aDigit )
        }
    }
    //------------------------------------------------------------------------
    private func m_ClearCol( col aCol: Int, digit aDigit: Int )
    {
        for row in 1..<10 {
            m_Board[ row, aCol ].mClearAllowed( digit: aDigit )
        }
    }
    //------------------------------------------------------------------------
    private func m_ClearSquare( row aRow: Int, col aCol: Int, digit aDigit: Int )
    {
        let rowRange = SquareRange( index: aRow )
        let colRange = SquareRange( index: aCol )
        for row in rowRange {
            for col in colRange {
                m_Board[ row, col ].mClearAllowed( digit: aDigit )
            }
        }
    }
    //------------------------------------------------------------------------
    private func m_ComputeRating( row aRow: Int, col aCol: Int, digit aDigit: Int ) -> Int
    {
        let rowRate = m_RateRow( row: aRow, digit: aDigit )
        let colRate = m_RateCol( col: aCol, digit: aDigit )
        let squareRate = m_RateSquare( row: aRow, col: aCol, digit: aDigit )
        return min( squareRate, min( rowRate, colRate ))
    }
    //------------------------------------------------------------------------
    private func m_RateRow( row aRow: Int, digit aDigit: Int ) -> Int
    {
        var rating = 0
        for col in 1..<10 {
            if m_Board[ aRow, col ].mbAllowed( digit: aDigit ) {
                rating += 1
            }
        }
        return rating
    }
    //------------------------------------------------------------------------
    private func m_RateCol( col aCol: Int, digit aDigit: Int ) -> Int
    {
        var rating = 0
        for row in 1..<10 {
            if m_Board[ row, aCol ].mbAllowed( digit: aDigit ) {
                rating += 1
            }
        }
        return rating
    }
    //------------------------------------------------------------------------
    private func m_RateSquare( row aRow: Int, col aCol: Int, digit aDigit: Int ) -> Int
    {
        let rowRange = SquareRange( index: aRow )
        let colRange = SquareRange( index: aCol )
        var rating = 0
        for row in rowRange {
            for col in colRange {
                if m_Board[ row, col ].mbAllowed(digit: aDigit ) {
                    rating += 1
                }
            }
        }
        return rating
    }
    //------------------------------------------------------------------------
    private class CCell
    {
        public init()
        {
        }
        public var mDigit: Int { Int( m_Digit ) }
        public var mCharDigit: Character { return m_Digit == 0 ? Character( "." ) : String( m_Digit ).first! }
        public func mbIsEmpty() -> Bool { return m_Digit == 0 }
        public func mbAllowed( digit aDigit: Int ) -> Bool
        {
            guard 0..<10 ~= aDigit else { return false }
            return mb_Allowed[ aDigit ]
        }
        public func mClearAllowed( digit aDigit: Int ) { mb_Allowed[ aDigit ] = false }
        public func mSetDigit( digit aDigit: Int )
        {
            m_Digit = UInt8( aDigit )
            mb_Allowed = [Bool].init( repeating: false, count: 10 )
        }
        public func mReset()
        {
            m_Digit = 0
            mResetAllowed()
        }
        public func mResetAllowed()
        {
            mb_Allowed = [Bool].init( repeating: true, count: 10 )
        }
        private var m_Digit : UInt8 = 0
        private var mb_Allowed = [Bool].init( repeating: true, count: 10 )
    }
    //#
    //############################################################################
    //# CSudoku.CBoard
    //#
    private class CBoard
    {
        public init()
        {
            m_Board = [[CCell]]()
            for _ in 0..<10 {
                var subArray = [CCell]()
                for _ in 0..<10 {
                    subArray.append( CCell())
                }
                m_Board.append(subArray)
            }
        }
        subscript( row: Int, column: Int ) -> CCell { m_Board[ row ][ column ] }

        private var m_Board : [[CCell]]
    }
    //#
    //# CSudoku.CBoard
    //############################################################################
    //#
    private var m_Nested: Int
    private var m_Board : CBoard
}
//#
//# CSudoku
//############################################################################
//#
//let game = CSudoku()
//
//game.mSetRow( row: 1, digits: "3.. .79 ..." )
//game.mSetRow( row: 2, digits: "... ... .1." )//[ 0, 0, 0,   0, 0, 0,   0, 1, 0 ] )
//game.mSetRow( row: 3, digits: "..8 3.. ..." )//[ 0, 0, 8,   3, 0, 0,   0, 0, 0 ] )
//
//game.mSetRow( row: 4, digits: "... .4. .7." )//[ 0, 0, 0,   0, 4, 0,   0, 7, 0 ] )
//game.mSetRow( row: 5, digits: "7.9 ... ..4" )//[ 7, 0, 9,   0, 0, 0,   0, 0, 4 ] )
//game.mSetRow( row: 6, digits: ".5. 9.. 3.6" )//[ 0, 5, 0,   9, 0, 0,   3, 0, 6 ] )
//
//game.mSetRow( row: 7, digits: ".74 ... 2.." )//[ 0, 7, 4,   0, 0, 0,   2, 0, 0 ] )
//game.mSetRow( row: 8, digits: ".1. 4.. ..." )//[ 0, 1, 0,   4, 0, 0,   0, 0, 0 ] )
//game.mSetRow( row: 9, digits: "53. .8. .9." )//[ 5, 3, 0,   0, 8, 0,   0, 9, 0 ] )
//
//game.mShowBoard()
//if game.mbSolve() {
//    game.mShowSolution()
//}
//print("Another game:")
//game.mReset()
//game.mSetRow( row: 1, digits: ".3. ..8 ..." )
//game.mSetRow( row: 2, digits: "... 32. ..." )
//game.mSetRow( row: 3, digits: "1.. ... 56." )
//
//game.mSetRow( row: 4, digits: ".9. 2.1 7.." )
//game.mSetRow( row: 5, digits: ".45 7.. ..9" )
//game.mSetRow( row: 6, digits: "6.. ... .5." )
//
//game.mSetRow( row: 7, digits: "... .9. .17" )
//game.mSetRow( row: 8, digits: "3.. ... ..5" )
//game.mSetRow( row: 9, digits: "..9 13. ..." )
//
//game.mShowBoard()
//if game.mbSolve() {
//    game.mShowSolution()
//}
