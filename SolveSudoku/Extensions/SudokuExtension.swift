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
    static public var gDepth = 0
    //------------------------------------------------------------------------
    public mutating func mbSolve( depth acDepth: Int = 1 ) -> Bool
    {
        if acDepth == 1 {
            Sudoku.gDepth = 1
        } else if acDepth > Sudoku.gDepth {
            Sudoku.gDepth = acDepth
        }
        if mb_Solved() {
            print("Solution: depth = \(Sudoku.gDepth)")
            mShowBoard()
            return true
        }
        mShowBoard()
        
        if mb_FillSingles() {
            if mb_Solved() {
                print("Solution: depth = \(Sudoku.gDepth)")
                mShowBoard()
                return true
            }
            let best = m_FindBestPos()
            
            if best.digits.count == 0 {
                //* No possibilities found
                return false
            }
            var index = 0
            for digit: UInt8 in best.digits {
                var helper: Sudoku = self
                index += 1
                print( "Try recursive[\(acDepth)] digit \(digit) [\(index) of \(best.digits.count)] at \(best.row) x \(best.col)" )
                helper.mSetDigit( row: best.row, col: best.col, digit )
                if helper.mbSolve( depth: acDepth + 1 ) {
                    self = helper
                    return true
                }
                print( "Rejected \(digit) at \(best.row) x \(best.col)" )
            }
        } else {
            print("NOT POSSIBLE!")
        }
        return false
    }
    //------------------------------------------------------------------------
    private func m_FindBestPos() -> ( row: Int, col: Int, digits: [UInt8] )
    {
        var best = ( row: 0, col: 0, digits: [UInt8]())

        for row in 0..<9 {
            for col in 0..<9 {
                guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                var digits = [UInt8]()

                for digit: UInt8 in 1...9 {
                    if mbIsAllowed( row: row, col: col, digit ) {
                        digits.append( digit )
                    }
                }
                if digits.count < best.digits.count || best.digits.count == 0 {
                    best.digits = digits
                    best.row = row
                    best.col = col
                    
                    if best.digits.count == 1 {
                        return best
                    }
                }
            }
        }
        return best
    }
    //------------------------------------------------------------------------
    private mutating func mb_FillSingles() -> Bool
    {
        var bSingles: Bool
        repeat {
            if !mb_StillPossible() {
                return false
            }
            bSingles = false
            for row in 0..<9 {
                for col in 0..<9 {
                    guard self[ row: row, col: col ].mbIsEmpty() else { continue }
                    var bestPossibilities = ( count: 10, digit: UInt8( 0 ))
                    var bestCount = ( count: 0, digit: UInt8( 0 ))
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
        return true
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
