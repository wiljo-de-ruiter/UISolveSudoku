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
            RoundedRectangle( cornerRadius: 7 )
                .fill( backColor )
                .aspectRatio(CGFloat(0.7), contentMode: .fit)// contentMode: .fill )
                .overlay() {
                    Text( "\(digit)" )
                        .fontWeight( selected ? .heavy : .light )
                        .font( .title )
                        .foregroundColor( Color.normalTextColor )
                }
        }
    }
}

struct EnterBar: View {
    @Binding var enter: Int
    
    var body: some View {
        HStack( spacing: 2 ) {
            Spacer()
            ForEach( 1..<10 ) { digit in
                EnterButton( enter: $enter, digit: digit )
            }
            Spacer()
        }
    }
}

struct EnterBar_Previews: PreviewProvider {
    static var previews: some View {
        EnterBar( enter: .constant( 3 ))
    }
}
