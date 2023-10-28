//
//  ContentView.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct BarcodeScannerView: View {
    let kScannerViewHeight: CGFloat = 280
    let kScannerViewBottomSpacing: CGFloat = 32
    let kStatusHorizontalPadding: CGFloat = 10
    let kStatusVerticalPadding: CGFloat = 4
    let kStatusCornerRadius: CGFloat = 15
    let kPlayButtonFrameSize: CGFloat = 50
    let kCopyButtonCornerRadius: CGFloat = 15
    
    @State private var isScanning: Bool = true
    @State private var scannedBarcode: String = ""
    @State private var cameraError: CameraError?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ScannerView(isScanning: $isScanning,
                            scannedBarcode: $scannedBarcode,
                            error: $cameraError)
                .frame(maxWidth: .infinity, maxHeight: kScannerViewHeight)
                .background(Color(.label))
                
                HStack {
                    Button {
                        isScanning.toggle()
                    } label: {
                        Image(systemName: isScanning ? "stop.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color(.systemBackground))
                    }
                    .padding()
                    .frame(width: kPlayButtonFrameSize, height: kPlayButtonFrameSize)
                    .background(
                        Circle().fill(isScanning ? .red : Color(.label))
                    )
                    
                    Button(action: copyBarcodeToPasteboard) {
                        Label("Copy", systemImage: "doc.on.doc.fill")
                            .foregroundStyle(Color(.systemBackground))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: kCopyButtonCornerRadius, style: .continuous)
                            .fill(Color(.label))
                    )
                }
                
                Spacer()
                
                VStack {
                    Label("ScannedBarcode: ",
                          systemImage: "barcode.viewfinder")
                    .padding()
                    .font(.title)
                    .fontWeight(.medium)
                    
                    Text(scannedBarcode.isEmpty ? "Nothing yet found" : scannedBarcode)
                        .foregroundStyle(scannedBarcode.isEmpty ? .red : .blue)
                        .bold()
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .background(.orange.gradient)
            .navigationTitle("🎥  Barcode Scanner")
        }
        .fullscreenAlert(alertObject: $cameraError) { err in
            AlertOverlayView(title: err.alertTitle,
                             message: err.rawValue,
                             buttonTitle: "Understood") {
                cameraError = nil
                isScanning = false
            }
        }
    }
    
    func copyBarcodeToPasteboard() {
        UIPasteboard
            .general
            .setValue(scannedBarcode, forPasteboardType: UTType.plainText.identifier)
    }
}

#Preview {
    BarcodeScannerView()
}
