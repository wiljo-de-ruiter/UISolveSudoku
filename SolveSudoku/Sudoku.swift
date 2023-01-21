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
        private var mb_Allowed = [Bool].init( repeating: true, count: 10 )
        //--------------------------------------------------------------------
        public var mDigit: UInt8 { m_Digit }
        public var mbLocked: Bool { mb_Locked }
        public var mCharDigit: Character { return m_Digit == 0 ? Character( "." ) : String( m_Digit ).first! }
        //--------------------------------------------------------------------
        public func mbIsEmpty() -> Bool { return m_Digit == 0 }
        //--------------------------------------------------------------------
        public mutating func mSetAllowed( digit acDigit: UInt8, _ abcAllowed: Bool )
        {
            assert( 0...9 ~= acDigit, "Digit out of range" )
            mb_Allowed[ Int( acDigit ) ] = abcAllowed
        }
        //--------------------------------------------------------------------
        public func mbAllowed( digit acDigit: UInt8 ) -> Bool
        {
            assert( 0...9 ~= acDigit, "Digit out of range" )
            return acDigit == 0 || ( m_Digit == 0 && mb_Allowed[ Int( acDigit ) ] )
        }
        //--------------------------------------------------------------------
        public mutating func mSetDigit( _ acDigit: UInt8 )
        {
            assert( 0...9 ~= acDigit, "Digit out of range" )
            m_Digit = acDigit
            mb_Locked = false
        }
        //--------------------------------------------------------------------
        public mutating func mLock( withDigit acDigit: UInt8 )
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
            mb_Allowed = [Bool].init( repeating: true, count: 10 )
        }
    }
    //------------------------------------------------------------------------
    public var mBoard = [Cell].init( repeating: Cell(), count: 100 )
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
    public func mbAllowed( row acRow:Int, col acCol: Int, _ acDigit: UInt8 ) -> Bool
    {
        assert( 0...9 ~= acDigit, "Digit out of range" )
        return self[ row: acRow, col: acCol ].mbAllowed( digit: acDigit )
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
    public mutating func mClear()
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
        let oldDigit = self[ row: acRow, col: acCol ].mDigit
        
        if acNewDigit != oldDigit {
            if oldDigit != 0 {
                mSetAllowed( row: acRow, col: acCol, digit: oldDigit, true )
            }
            self[ row: acRow, col: acCol ].mSetDigit( acNewDigit )
            
            if acNewDigit != 0 {
                mSetAllowed( row: acRow, col: acCol, digit: acNewDigit, false )
            }
        }
    }
    //------------------------------------------------------------------------
    private mutating func mSetAllowed( row acRow: Int, col acCol: Int, digit acDigit: UInt8, _ abcAllowed: Bool )
    {
        for idx in 0..<9 {
            self[ row: idx, col: acCol ].mSetAllowed( digit: acDigit, abcAllowed )
            self[ row: acRow, col: idx ].mSetAllowed( digit: acDigit, abcAllowed )
        }
        let rowRange = SquareRange( index: acRow )
        let colRange = SquareRange( index: acCol )
        for row in rowRange {
            for col in colRange {
                self[ row: row, col: col ].mSetAllowed( digit: acDigit, abcAllowed )
            }
        }
    }
    //-----------------------------------------------------------------------
    public mutating func mLock( row acRow: Int, col acCol: Int, withDigit acNewDigit: UInt8 )
    {
        let oldDigit = self[ row: acRow, col: acCol ].mDigit
        
        if acNewDigit != oldDigit {
            if oldDigit != 0 {
                mSetAllowed( row: acRow, col: acCol, digit: oldDigit, true )
            }
            self[ row: acRow, col: acCol ].mLock( withDigit: acNewDigit )
            
            if acNewDigit != 0 {
                mSetAllowed( row: acRow, col: acCol, digit: acNewDigit, false )
            }
        }
    }
}
//#
//# Sudoku # Sudoku # Sudoku # Sudoku  #  Sudoku # Sudoku # Sudoku # Sudoku #
//###########################################################################
//#
