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
                    .aspectRatio(CGFloat(0.6), contentMode: .fit)// contentMode: .fill )
//                    .overlay() {
//                        Text( "\(digit)" )
//                            .fontWeight( selected ? .heavy : .light )
//                            .font( .title )
//                            .foregroundColor( Color.normalTextColor )
//                    }
                RoundedRectangle( cornerRadius: 7 )
                    .stroke(Color.normalTextColor, lineWidth: 3 )
                    .aspectRatio(CGFloat(0.6), contentMode: .fit)// contentMode: .fill )
                    .overlay() {
                        Text( "\(digit)" )
                            .fontWeight( selected ? .heavy : .light )
                            .font( .title )
                            .foregroundColor( Color.normalTextColor )
                    }
            }
        }
    }
}

struct EnterBar: View {
    @Binding var enter: Int
    
    var body: some View {
        HStack {
            Spacer()
            ForEach( 1..<10 ) { digit in
                EnterButton( enter: $enter, digit: digit )
            }
            Spacer()
        }

/*        VStack( spacing: 2 ) {
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
        }*/
    }
}

struct EnterBar_Previews: PreviewProvider {
    static var previews: some View {
        EnterBar( enter: .constant( 3 ))
    }
}
