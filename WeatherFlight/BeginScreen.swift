//
//  BeginScreen.swift
//  WeatherFlight
//
//  Created by CETYS Universidad  on 14/05/25.
//

import SwiftUI

struct BeginScreen: View {
    @StateObject private var permissionsViewModel = PermissionsViewModel()
    var body: some View {
    
        
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(colors: [.blue.opacity(0.6), .blue, .blue.opacity(0.9), .yellow], startPoint: .topLeading, endPoint: .bottom))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                Text("Weather Flight")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: 300, minHeight: 80)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(800)
                    .position(x:185,y:200)
                    .padding()
                
                Button(action: {
            permissionsViewModel.requestLocationAccess()
                }) {
                    Text("Please grant location access!")
                        .font(.headline)
                        .frame(maxWidth: 300, minHeight: 44)
                }
                .disabled(permissionsViewModel.locationGranted)
                .buttonStyle(.borderedProminent)
                .tint(.black.opacity(0.75))
                .position(x: 200, y: 75)
            }
            
        }
        
    }
        
}

#Preview {
    BeginScreen()
}
