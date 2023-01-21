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
    mutating func mbSolve() -> Bool
    {
        var bNotSolved = false
        var bSingles = false

        repeat {
            var bestRating = 9
            var bestRow = -1
            var bestCol = -1
            bNotSolved = false
            bSingles = false

            for row in 0..<9 {
                for col in 0..<9 {
                    guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                    var digitCount = 0
                    var bestDigit: UInt8 = 0
                    for digit: UInt8 in 1...9 {
                        if mbAllowed( row: row, col: col, digit ) {
                            bestDigit = digit
                            digitCount += 1
                        }
                    }
                    switch digitCount {
                    case 0:
                        return false
                        
                    case 1:
                        mSetDigit( row: row, col: col, bestDigit )
                        bSingles = true
                        
                    default:
                        for digit: UInt8 in 1...9 {
                            if mbAllowed( row: row, col: col, digit ) {
                                let rating = m_ComputeRating( row: row, col: col, digit: digit )
                                if rating == 1 {
                                    mSetDigit( row: row, col: col, digit )
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
            if !bSingles && bestRow >= 0 && bestCol >= 0 {
                for digit: UInt8 in 1...9 {
                    if mbAllowed( row: bestRow, col: bestCol, digit ) {
                        var helper: Sudoku = self
                        print( "Try recursive \(digit) at \(bestRow) x \(bestCol)" )
                        helper.mSetDigit( row: bestRow, col: bestCol, digit )
                        if helper.mbSolve() {
                            self = helper
                            return true
                        }
                        print( "Rejected \(digit) at \(bestRow) x \(bestCol)" )
                    }
                }
                return false
            }
        } while bNotSolved
        
        return true
    }

    //------------------------------------------------------------------------
    private func m_ComputeRating( row acRow: Int, col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        let rowRate = m_RateRow( row: acRow, digit: acDigit )
        let colRate = m_RateCol( col: acCol, digit: acDigit )
        let squareRate = m_RateSquare( row: acRow, col: acCol, digit: acDigit )
        return min( squareRate, min( rowRate, colRate ))
    }
    //------------------------------------------------------------------------
    private func m_RateRow( row acRow: Int, digit acDigit: UInt8 ) -> Int
    {
        var rating = 0
        for col in 0..<9 {
            if mbAllowed( row: acRow, col: col, acDigit ) {
                rating += 1
            }
        }
        return rating
    }
    //------------------------------------------------------------------------
    private func m_RateCol( col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        var rating = 0
        for row in 0..<9 {
            if mbAllowed( row: row, col: acCol, acDigit ) {
                rating += 1
            }
        }
        return rating
    }
    //------------------------------------------------------------------------
    private func m_RateSquare( row acRow: Int, col acCol: Int, digit acDigit: UInt8 ) -> Int
    {
        let rowRange = SquareRange( index: acRow )
        let colRange = SquareRange( index: acCol )
        var rating = 0
        for row in rowRange {
            for col in colRange {
                if mbAllowed( row: row, col: col, acDigit ) {
                    rating += 1
                }
            }
        }
        return rating
    }
}
