//
//  ScanView.swift
//  CaptureText
//
//  Created by Home on 28/4/23.
//

import SwiftUI
import VisionKit
import AVFoundation

struct ScanView: UIViewControllerRepresentable {
    @ObservedObject var scanProvider: ScanProvider
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text()],
                                                                  qualityLevel: .fast,
                                                                  isHighlightingEnabled: true)
        dataScannerViewController.delegate = scanProvider
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) {
    }
}

final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject {
    @Published var text: String = ""
    @Published var error: DataScannerViewController.ScanningUnavailable?
    @Published var showSheet = false
    let synthesizer = AVSpeechSynthesizer()
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let recognizedText):
            self.text = recognizedText.transcript
            self.showSheet.toggle()
            print(recognizedText)
        case .barcode(_):
            break
        @unknown default:
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController,
                     becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        self.error = error
        print(error)
    }
    
    func speak() {
        let textCopy = text
        let utterance = AVSpeechUtterance(string: textCopy)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        
        synthesizer.pauseSpeaking(at: .word)
        synthesizer.speak(utterance)
    }
}
