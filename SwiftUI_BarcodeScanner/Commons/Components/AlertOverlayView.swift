//
//  AlertOverlayView.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import SwiftUI

struct AlertOverlayView: View {
    let kAlertWindowMaximumWidth: CGFloat = 280
    let kAlertWindowCornerRadius: CGFloat = 25
    
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding()
                
                Divider()
                
                Text(message)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .padding(.vertical)
                
                Button(action: action,
                       label: {
                   Text(buttonTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                })
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.blue)
            }
            .frame(maxWidth: kAlertWindowMaximumWidth)
            .padding()
            .background(
               RoundedRectangle(cornerRadius: kAlertWindowCornerRadius, style: .continuous)
                .fill(.white)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.black.withAlphaComponent(0.6)))
        .onTapGesture(perform: action)
    }
}
