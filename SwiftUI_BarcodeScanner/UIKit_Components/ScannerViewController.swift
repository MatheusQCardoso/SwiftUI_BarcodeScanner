//
//  UIScannerVC.swift
//  SwiftUI_BarcodeScanner
//
//  Created by Matheus Quirino Cardoso on 27/10/23.
//

import UIKit
import AVFoundation

protocol ScannerVCDelegate: AnyObject {
    func found(barcode: String)
    func surface(error: CameraError)
}

final class ScannerViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: ScannerVCDelegate?
    
    init(delegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCatureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer else { 
            delegate?.surface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCatureSession() {
        guard let device = AVCaptureDevice.default(for: .video) else { 
            delegate?.surface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        let metaDataOutput = AVCaptureMetadataOutput()
        
        do {
            try videoInput = AVCaptureDeviceInput(device: device)
        } catch {
            delegate?.surface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput), captureSession.canAddOutput(metaDataOutput) {
            captureSession.addInput(videoInput)
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            delegate?.surface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        guard let previewLayer else { 
            delegate?.surface(error: .invalidDeviceInput)
            return
        }
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func startRecording() {
        setupCatureSession()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func stopRecording() {
        captureSession.stopRunning()
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first,
              let readableObject = object as? AVMetadataMachineReadableCodeObject,
              let barcode = readableObject.stringValue
        else {
            delegate?.surface(error: .invalidScanValue)
            return
        }
        delegate?.found(barcode: barcode)
    }
    
}
