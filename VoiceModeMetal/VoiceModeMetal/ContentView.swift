//
//  ContentView.swift
//  VoiceModeMetal
//
//  Created by Minsang Choi on 1/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        LinearGradient(colors: [.white.mix(with:.blue,by:0.1), .blue], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.4, y: 0.6))                .frame(width:390,height:400)
            .layerEffect(ShaderLibrary.fractalNoiseBlueWhite(.boundingRect, .float(progress), .float(2.0)), maxSampleOffset:.zero)
            .mask(
                Circle()
                    .frame(width:300,height:300)
            )

        Image("sample")
            .resizable()
            .scaledToFill()
            .frame(width:330,height:320)
            .blur(radius:10)
            .layerEffect(ShaderLibrary.fractalNoiseBlueWhite(.boundingRect, .float(progress),.float(2.0)), maxSampleOffset:.zero)
            .mask(
                Circle()
                    .frame(width:300,height:300)
            )
            .onAppear {
                withAnimation(.linear(duration: 30).repeatForever(autoreverses: true)){
                    progress = 6
                }
            }

    }
}

#Preview {
    ContentView()
}
