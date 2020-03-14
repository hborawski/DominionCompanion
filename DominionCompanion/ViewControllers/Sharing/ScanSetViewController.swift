//
//  ScanSetViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 3/14/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ScanSetViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!

    var captureSession: AVCaptureSession?
    
    var importSucceeded: (() -> Void)?
    
    override func viewDidLoad() {
        startCaptureSession()
    }
    
    func startCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard
            let videoDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            return
        }
        let output = AVCaptureMetadataOutput()
        guard
            let captureSession = captureSession,
            captureSession.canAddInput(videoInput),
            captureSession.canAddOutput(output)
        else { return }
        captureSession.addInput(videoInput)
        captureSession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(doneButton)

        captureSession.startRunning()
    }
    
    func showAlert(cards: [Card]) {
        let alert = UIAlertController(title: "Set Found!", message: "Would you like to import the set over your currently pinned cards?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Import", style: .default, handler: { (action) in
            SetBuilder.shared.pinnedCards = cards
            self.importSucceeded?()
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.captureSession?.startRunning()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension ScanSetViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let session = captureSession else { return }
        session.stopRunning()
        
        guard
            let metaData = metadataObjects.first,
            let readableObject = metaData as? AVMetadataMachineReadableCodeObject,
            let stringData = readableObject.stringValue?.data(using: .utf8),
            let cardNames = try? JSONDecoder().decode([String].self, from: stringData)
        else { return dismiss(animated: true) }
        
        let cards = cardNames.compactMap { (name) -> Card? in
            return CardData.shared.kingdomCards.first(where: {$0.name == name})
        }
        
        showAlert(cards: cards)
    }
}
