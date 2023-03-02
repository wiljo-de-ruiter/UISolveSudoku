//
//  EnterBar.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-27.
//

import SwiftUI

struct EnterButton: View {
    @Binding var enter: Int
    public let digit: Int
    
    var body: some View {
        Button( action: {
            enter = digit
        }) {
            let selected = enter != 0 && digit == enter
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
    @Binding var enter: Int
    let columns = [
        GridItem(.flexible(minimum: 64, maximum: 100)),
        GridItem(.flexible(minimum: 64, maximum: 100)),
        GridItem(.flexible(minimum: 64, maximum: 100)),
        ]
    var body: some View {
        LazyVGrid( columns: columns, spacing: 4 ) {
            ForEach( 1..<10 ) { digit in
                EnterButton( enter: $enter, digit: digit )
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
        EnterGrid( enter: .constant( 3 ))
    }
}
