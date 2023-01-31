//
//  Sudoku.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-21.
//

import Foundation
//#
//###########################################################################
//# Sudoku # Sudoku # Sudoku # Sudoku  #  Sudoku # Sudoku # Sudoku # Sudoku #
//#
struct Sudoku
{
    //#
    //########################################################################
    //# Cell
    //#
    struct Cell
    {
        private var m_Digit: UInt8 = 0
        private var mb_Locked: Bool = false
        //--------------------------------------------------------------------
        public var mDigit: UInt8 { m_Digit }
        public var mbLocked: Bool { mb_Locked }
        public var mCharDigit: Character { return m_Digit == 0 ? Character( "." ) : String( m_Digit ).first! }
        //--------------------------------------------------------------------
        public func mbIsEmpty() -> Bool { return m_Digit == 0 }
        //--------------------------------------------------------------------
        public mutating func mSetDigit( _ acDigit: UInt8 )
        {
            assert( 0...9 ~= acDigit, "Digit out of range" )
            m_Digit = acDigit
            mb_Locked = false
        }
        //--------------------------------------------------------------------
        public mutating func mLockDigit( _ acDigit: UInt8 )
        {
            assert( 0...9 ~= acDigit, "Digit out of range" )
            m_Digit = acDigit
            mb_Locked = m_Digit > 0
        }
        //--------------------------------------------------------------------
        public mutating func mClear()
        {
            m_Digit = 0
            mb_Locked = false
        }
    }
    //------------------------------------------------------------------------
    public var mBoard = [Cell].init( repeating: Cell(), count: 100 )
    //------------------------------------------------------------------------
    init()
    {
//        mLockRow( row: 0, with: "........9" )
//        mLockRow( row: 1, with: "51...9.7." )
//        mLockRow( row: 2, with: "89.2.56.." )
//        mLockRow( row: 3, with: "..3.97..." )
//        mLockRow( row: 4, with: "..9...7.." )
//        mLockRow( row: 5, with: "...36.5.." )
//        mLockRow( row: 6, with: "..54.8.27" )
//        mLockRow( row: 7, with: ".8.7...16" )
//        mLockRow( row: 8, with: "4........" )

//        mLockRow( row: 0, with: "....62" )
//        mLockRow( row: 1, with: "..159..7" )
//        mLockRow( row: 2, with: "259..4" )
//        mLockRow( row: 3, with: ".9..7...5" )
//        mLockRow( row: 4, with: "6.......1" )
//        mLockRow( row: 5, with: "5...8..4" )
//        mLockRow( row: 6, with: "...6..758" )
//        mLockRow( row: 7, with: ".8..276" )
//        mLockRow( row: 8, with: "...83" )
//
//        mLockRow( row: 0, with: "9.372...6" )
//        mLockRow( row: 1, with: "7..6148" )
//        mLockRow( row: 2, with: "" )
//        mLockRow( row: 3, with: ".5..9.17" )
//        mLockRow( row: 4, with: "2468" )
//        mLockRow( row: 5, with: "197253..8" )
//        mLockRow( row: 6, with: "67...528" )
//        mLockRow( row: 7, with: "489" )
//        mLockRow( row: 8, with: ".32.8.6" )
        
        mLockRow( row: 0, with: "" )
        mLockRow( row: 1, with: "9.2...5.7" )
        mLockRow( row: 2, with: "4...7..86" )
        mLockRow( row: 3, with: "2961" )
        mLockRow( row: 4, with: "18" )
        mLockRow( row: 5, with: "7....51" )
        mLockRow( row: 6, with: "..9..4.5" )
        mLockRow( row: 7, with: "......82" )
        mLockRow( row: 8, with: "86..3" )
    }
    //------------------------------------------------------------------------
    subscript( row acRow: Int, col acCol: Int ) -> Cell
    {
        get {
            assert( 0..<9 ~= acRow && 0..<9 ~= acCol, "Cell out of range" )
            return mBoard[ acRow * 9 + acCol ]
        }
        set {
            assert( 0..<9 ~= acRow && 0..<9 ~= acCol, "Cell out of range" )
            mBoard[ acRow * 9 + acCol ] = newValue
        }
    }
    //------------------------------------------------------------------------
    public func mbHasDigits( count acCount: Int ) -> Bool
    {
        var count = 0;
        for row in 0..<9 {
            for col in 0..<9 {
                if self[ row: row, col: col ].mDigit > 0 {
                    count += 1
                }
            }
        }
        return count >= acCount
    }
    //------------------------------------------------------------------------
    public mutating func mbClearNotLocked() -> Bool
    {
        var bCleared = false
        for row in 0..<9 {
            for col in 0..<9 {
                if !self[ row: row, col: col ].mbLocked {
                    if !self[ row: row, col: col ].mbIsEmpty() {
                        self[ row: row, col: col ].mClear()
                        bCleared = true
                    }
                }
            }
        }
        return bCleared
    }
    //------------------------------------------------------------------------
    public mutating func mClearAll()
    {
        for row in 0..<9 {
            for col in 0..<9 {
                self[ row: row, col: col ].mClear()
            }
        }
    }
    //------------------------------------------------------------------------
    public mutating func mSetDigit( row acRow: Int, col acCol: Int, _ acNewDigit: UInt8 )
    {
        self[ row: acRow, col: acCol ].mSetDigit( acNewDigit )
    }
    //-----------------------------------------------------------------------
    public mutating func mLockDigit( row acRow: Int, col acCol: Int, _ acNewDigit: UInt8 )
    {
        self[ row: acRow, col: acCol ].mLockDigit( acNewDigit )
    }
    //------------------------------------------------------------------------
    public mutating func mLockRow( row acRow: Int, with acDigits: String )
    {
        var col = 0
        for char in acDigits {
            if let digit = char.wholeNumberValue {
                if !mbIsAllowed( row: acRow, col: col, UInt8( digit )) {
                    print("ERROR: digit \(digit) not allowed at \(acRow) x \(col)")
                    return
                }
                mLockDigit( row: acRow, col: col, UInt8( digit ))
            }
            col += 1
        }
    }
    //------------------------------------------------------------------------
    public func mShowBoard( solution acSolution: Bool = false )
    {
        if acSolution {
            print("+------ Solution -------+")
        } else {
            print("+-------+-------+-------+")
        }
        for row in 0..<9 {
            var line = "| "
            if row == 3 || row == 6 {
                print("+-------+-------+-------+")
            }
            for col in 0..<9 {
                if col == 3 || col == 6 { line += "| " }
                line.append( self[ row: row, col: col ].mCharDigit )
                line.append( " " )
            }
            line.append("|")
            print( line )
        }
        print("+-------+-------+-------+")
    }
    //------------------------------------------------------------------------
    public func mbIsAllowed( row acRow: Int, col acCol: Int, _ acDigit: UInt8 ) -> Bool
    {
        if acDigit > 9 || self[ row: acRow, col: acCol ].mDigit > 0 {
            return false
        }
        if acDigit > 0 {
            for idx in 0..<9 {
                if acDigit == self[ row: idx, col: acCol ].mDigit {
                    return false
                }
                if acDigit == self[ row: acRow, col: idx ].mDigit {
                    return false
                }
            }
            let rowRange = SquareRange( index: acRow )
            let colRange = SquareRange( index: acCol )
            for row in rowRange {
                for col in colRange {
                    if acDigit == self[ row: row, col: col ].mDigit {
                        return false
                    }
                }
            }
        }
        return true
    }
}
//#
//# Sudoku # Sudoku # Sudoku # Sudoku  #  Sudoku # Sudoku # Sudoku # Sudoku #
//###########################################################################
//#
