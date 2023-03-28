//
//  EnterBar.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-27.
//

import SwiftUI

struct EnterButton: View {
    @EnvironmentObject var global: CGlobalData
    @EnvironmentObject var game: CSudoku
    public let digit: UInt8
    
    var body: some View {
        Button( action: {
            global.mEnter = digit
        }) {
            let selected = global.mEnter != 0 && digit == global.mEnter
            let backColor = selected ? Color.selectedBackColor : Color.lightLineColor
            ZStack {
                RoundedRectangle( cornerRadius: 7 )
                    .fill( backColor )
                    .aspectRatio(CGFloat(1), contentMode: .fit)
                
                RoundedRectangle( cornerRadius: 7 )
                    .stroke( Color.normalTextColor, lineWidth: 2 )
                    .aspectRatio( CGFloat(1), contentMode: .fit )
                    .overlay() {
                        Text( "\(digit)" )
                            .fontWeight( selected ? .heavy : .light )
                            .font( .title )
                            .foregroundColor( Color.normalTextColor )
                    }
            }
            .padding(2)
        }
    }
}

struct EnterGrid: View {
    let columns = [
        GridItem(.flexible(minimum: 64, maximum: 100)),
        GridItem(.flexible(minimum: 64, maximum: 100)),
        GridItem(.flexible(minimum: 64, maximum: 100)),
        ]
    var body: some View {
        LazyVGrid( columns: columns, spacing: 4 ) {
            ForEach( 1..<10 ) { digit in
                EnterButton( digit: UInt8( digit ))
                    .frame( width: 60, height: 60 )
                    .fixedSize()
                    .padding(5)
            }
        }

/*
        VStack( spacing: 2 ) {
            HStack {
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                }
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "circle").foregroundColor(.white)
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "circle").foregroundColor(.white)
                        Image(systemName: "circle").foregroundColor(.white)
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                }
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "circle").foregroundColor(.white)
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                }
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                }
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                        Image(systemName: "a.circle")
                    }
                }
                VStack {
                    HStack( spacing: 0 ) {
                        Image(systemName: "a.circle")
                    }
                }
            }
        } */
    }
}

struct EnterBar_Previews: PreviewProvider {
    static var previews: some View {
        EnterGrid().environmentObject(CSudoku())
    }
}
