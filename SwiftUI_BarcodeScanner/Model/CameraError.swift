//
//  CameraError.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import UIKit

enum CameraError: String, Error, Identifiable {
    var id: UUID { .init() }
    
    case invalidDeviceInput         = "Something is wrong with your device's camera. We were unable to capture it's input."
    case invalidScanValue           = "The scanned data format was invalid. (Valid: EAN-8 & EAN-13)"
    
    var alertTitle: String {
        return switch self {
        case .invalidDeviceInput: "Invalid Device Input"
        case .invalidScanValue: "Invalid Scanned Value"
        }
    }
}

extension CameraError: LocalizedError {
    var errorDescription: String? { self.rawValue }
}
