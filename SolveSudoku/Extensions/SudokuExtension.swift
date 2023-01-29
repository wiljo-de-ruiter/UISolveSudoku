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
    let start = aIndex - aIndex % 3
    return start ..< start + 3
}
//#
//############################################################################
//# Sudoku extension
//#
extension Sudoku
{
    public mutating func mbSolve2( depth acDepth: Int = 1 ) -> Bool
    {
        if mb_Solved() {
            print("Solution:")
            mShowBoard()
            return true
        }
        mShowBoard()
        
        if mb_StillPossible() {
            var bestPossibilities = 10
            var bestRow = -1
            var bestCol = -1
            
            m_FillSingles()

            if mb_Solved() {
                print("Solution:")
                mShowBoard()
                return true
            }
            for row in 0..<9 {
                for col in 0..<9 {
                    guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                    var possibilities = 0

                    for digit: UInt8 in 1...9 {
                        if mbIsAllowed( row: row, col: col, digit ) {
                            possibilities += 1
                        }
                    }
                    if possibilities < bestPossibilities {
                        bestPossibilities = possibilities
                        bestRow = row
                        bestCol = col
                    }
                }
            }
            if bestRow < 0 {
                //* No possibilities found
                return false
            }
            var index = 0
            for digit: UInt8 in 1...9 {
                if mbIsAllowed( row: bestRow, col: bestCol, digit ) {
                    var helper: Sudoku = self
                    index += 1
                    print( "Try recursive[\(acDepth)] digit \(digit) [\(index) of \(bestPossibilities)] at \(bestRow) x \(bestCol)" )
                    helper.mSetDigit( row: bestRow, col: bestCol, digit )
                    if helper.mbSolve2( depth: acDepth + 1 ) {
                        self = helper
                        return true
                    }
                    print( "Rejected \(digit) at \(bestRow) x \(bestCol)" )
                }
            }
        } else {
            print("NOT POSSIBLE!")
        }
        return false
    }
    //------------------------------------------------------------------------
    private mutating func m_FillSingles()
    {
        var bSingles: Bool
        repeat {
            bSingles = false
            for row in 0..<9 {
                for col in 0..<9 {
                    guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                    var bestPossibilities = ( digit: UInt8( 0 ), count: 10 )
                    var bestCount = ( digit: UInt8( 0 ), count: 0)
                    for digit: UInt8 in 1...9 {
                        if mbIsAllowed( row: row, col: col, digit ) {
                            bestCount.count += 1
                            bestCount.digit = digit
                            
                            let possibilities = m_ComputePossibilities( row: row, col: col, digit: digit )
                            if possibilities < bestPossibilities.count {
                                bestPossibilities.count = possibilities
                                bestPossibilities.digit = digit
                            }
                        }
                    }
                    if bestCount.count == 1 {
                        mSetDigit( row: row, col: col, bestCount.digit )
                        print("Found single digit \(bestCount.digit) at \(row) x \(col)")
                        bSingles = true
                        mShowBoard()
                    } else if bestPossibilities.count == 1 {
                        mSetDigit( row: row, col: col, bestPossibilities.digit )
                        print("Found single digit \(bestPossibilities.digit) at \(row) x \(col)")
                        bSingles = true
                        mShowBoard()
                    }
                }
            }
        } while( bSingles )
    }
    //------------------------------------------------------------------------
    private func m_ComputePossibilities( row acRow: Int, col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        let rowRate = m_RowPossibilities( row: acRow, digit: acDigit )
        let colRate = m_ColPossibilities( col: acCol, digit: acDigit )
        let squareRate = m_SquarePossibilities( row: acRow, col: acCol, digit: acDigit )
        return min( squareRate, min( rowRate, colRate ))
    }
    //------------------------------------------------------------------------
    private func m_RowPossibilities( row acRow: Int, digit acDigit: UInt8 ) -> Int
    {
        var nrPossibilities = 0
        for col in 0..<9 {
            if mbIsAllowed( row: acRow, col: col, acDigit ) {
                nrPossibilities += 1
            }
        }
        return nrPossibilities
    }
    //------------------------------------------------------------------------
    private func m_ColPossibilities( col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        var nrPossibilities = 0
        for row in 0..<9 {
            if mbIsAllowed( row: row, col: acCol, acDigit ) {
                nrPossibilities += 1
            }
        }
        return nrPossibilities
    }
    //------------------------------------------------------------------------
    private func m_SquarePossibilities( row acRow: Int, col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        let rowRange = SquareRange( index: acRow )
        let colRange = SquareRange( index: acCol )
        var nrPossibilities = 0
        for row in rowRange {
            for col in colRange {
                if mbIsAllowed( row: row, col: col, acDigit ) {
                    nrPossibilities += 1
                }
            }
        }
        return nrPossibilities
    }
    //------------------------------------------------------------------------
    private func mb_Solved() -> Bool
    {
        for row in 0..<9 {
            for col in 0..<9 {
                if self[ row: row, col: col ].mbIsEmpty() {
                    return false
                }
            }
        }
        return true
    }
    //------------------------------------------------------------------------
    private func mb_StillPossible() -> Bool
    {
        for row in 0..<9 {
            for col in 0..<9 {
                guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                var bPossible = false
                for digit: UInt8 in 1...9 {
                    if mbIsAllowed( row: row, col: col, digit ) {
                        bPossible = true
                        break
                    }
                }
                if !bPossible {
                    return false
                }
            }
        }
        return true
    }
}
