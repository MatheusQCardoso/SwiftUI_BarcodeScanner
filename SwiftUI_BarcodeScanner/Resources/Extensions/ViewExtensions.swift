//
//  ViewExtensions.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func fullscreenAlert<Content: View, T: Hashable>(alertObject: Binding<T?>, @ViewBuilder content: @escaping (T) -> Content) -> some View {
        self.modifier(FullscreenAlertModifier(object: alertObject, alertContent: content))
    }
}

//MARK: - MODIFIERS -
fileprivate struct FullscreenAlertModifier<AlertContent: View, T: Hashable>: ViewModifier {
    
    @Binding var object: T?
    @ViewBuilder var alertContent: (T) -> AlertContent
    
    func body(content: Content) -> some View {
        if let object = object {
            content.overlay {
                alertContent(object)
            }
        } else {
            content
        }
    }
}
