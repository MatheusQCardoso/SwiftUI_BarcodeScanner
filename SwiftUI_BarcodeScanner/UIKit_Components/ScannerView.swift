//
//  ScannerView.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import SwiftUI
 
struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var isScanning: Bool
    @Binding var scannedBarcode: String
    @Binding var error: CameraError?
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        ScannerViewController(delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        if isScanning {
            uiViewController.startRecording()
        } else {
            uiViewController.stopRecording()
            error = nil
        }
    }
    
    func makeCoordinator() -> Coordinator { 
        Self.Coordinator(scannerView: self)
    }
    
    final class Coordinator: ScannerVCDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func found(barcode: String) {
            scannerView.scannedBarcode = barcode
        }
        
        func surface(error: CameraError) {
            if scannerView.error != error {
                scannerView.error = error
            }
        }
    }
}

#Preview {
    ScannerView(isScanning: .constant(true), scannedBarcode: .constant("12345678"), error: .constant(nil))
}
