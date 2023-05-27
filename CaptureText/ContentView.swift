//
//  ContentView.swift
//  CaptureText
//
//  Created by Home on 28/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var scanProvider = ScanProvider()
    
    var body: some View {
        ScanView(scanProvider: scanProvider)
            .sheet(isPresented: $scanProvider.showSheet) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            scanProvider.speak()
                        } label: {
                            Label("Play", systemImage: "play.fill")
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                    Text(scanProvider.text)
                        .font(.system(.body, design: .rounded))
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium, .large])
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
