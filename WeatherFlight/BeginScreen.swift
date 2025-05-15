//
//  BeginScreen.swift
//  WeatherFlight
//
//  Created by CETYS Universidad  on 14/05/25.
//

import SwiftUI

struct BeginScreen: View {
    var body: some View {
    
        
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(colors: [.blue.opacity(0.6), .blue, .blue.opacity(0.9), .yellow], startPoint: .topLeading, endPoint: .bottom))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                Text("WEATHERBYTE")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(10)
                    .position(x:185,y:200)
                    .padding()
                Spacer()
            }
            .navigationTitle("Profile")
        }
        
    }
        
}

#Preview {
    BeginScreen()
}
