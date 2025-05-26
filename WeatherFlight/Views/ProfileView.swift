//
//  ProfileView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var flightManager: FlightManager
    @State private var showingExport = false
    @State private var showingAbout = false
    @Environment(\.colorScheme) var colorScheme
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var profileImageURL: URL? = nil
    @State private var isLoadingImage = false
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? Color(red: 0.05, green: 0.1, blue: 0.2) : Color(red: 0.96, green: 0.94, blue: 0.89))
                    .edgesIgnoringSafeArea(.all)
                
                Group {
                    if !isLoggedIn {
                        // Show login button centered
                        VStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    isLoggedIn = true
                                }
                            }) {
                                Text("Iniciar sesión")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(colorScheme == .dark ? Color.blue : Color.brown)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(color: (colorScheme == .dark ? Color.blue : Color.brown).opacity(0.25), radius: 8)
                                    .padding(.horizontal, 60)
                            }
                            Spacer()
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                if profileImageURL == nil {
                                    // Show username and password fields, and "Iniciar sesión" button
                                    VStack(spacing: 16) {
                                        // Username field with input filtering
                                        TextField("Ingrese nombre de usuario", text: Binding(
                                            get: { self.username },
                                            set: { newValue in
                                                // Only allow [A-Za-z0-9_]* in real time
                                                let filtered = newValue.filter { $0.isLetter || $0.isNumber || $0 == "_" }
                                                self.username = filtered
                                            }
                                        ))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding(.horizontal, 40)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                            .disabled(isLoadingImage)
                                            .opacity(isLoadingImage ? 0.5 : 1)

                                        // Password field
                                        SecureField("Contraseña", text: $password)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding(.horizontal, 40)
                                            .disabled(isLoadingImage)
                                            .opacity(isLoadingImage ? 0.5 : 1)
                                        
                                        Button(action: {
                                            generateProfileImage()
                                        }) {
                                            Text("Iniciar sesión")
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background((username.isEmpty || password.isEmpty || isLoadingImage) ? Color.gray.opacity(0.5) : (colorScheme == .dark ? Color.blue : Color.brown))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        .disabled(username.isEmpty || password.isEmpty || isLoadingImage)
                                        .padding(.horizontal, 40)
                                        
                                        if isLoadingImage {
                                            ProgressView()
                                                .padding(.top, 20)
                                        }
                                    }
                                    .padding(.top, 40)
                                } else {
                                    // Show profile image, username, and options with animation
                                    VStack(spacing: 16) {
                                        AsyncImage(url: profileImageURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 120, height: 120)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(colorScheme == .dark ? Color.blue : Color.brown, lineWidth: 2))
                                                    .padding(.top, 40)
                                                    .transition(.opacity.combined(with: .scale))
                                            case .failure(_):
                                                Image(systemName: "person.crop.circle.badge.exclamationmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 120)
                                                    .foregroundColor(colorScheme == .dark ? .blue : .brown)
                                                    .padding(.top, 40)
                                                    .transition(.opacity.combined(with: .scale))
                                            @unknown default:
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 120, height: 120)
                                                    .foregroundColor(colorScheme == .dark ? .blue : .brown)
                                                    .padding(.top, 40)
                                                    .transition(.opacity.combined(with: .scale))
                                            }
                                        }
                                        
                                        Text(username.isEmpty ? "Usuario anónimo" : username)
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .transition(.opacity.combined(with: .scale))
                                        
                                        Divider()
                                            .frame(width: 200)
                                            .background(colorScheme == .dark ? Color.blue.opacity(0.5) : Color.brown.opacity(0.5))
                                    }
                                    .animation(.easeInOut, value: profileImageURL)
                                    .padding(.bottom, 30)
                                    
                                    // PROFILE BUTTONS
                                    VStack(spacing: 16) {
                                        ProfileButton(
                                            icon: "info.circle",
                                            text: "Acerca de WeatherFlight",
                                            color: colorScheme == .dark ? .blue : .brown
                                        ) {
                                            showingAbout = true
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                    
                                    // SIGN OUT
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            signOut()
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                            Text("Cerrar sesión")
                                        }
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(colorScheme == .dark ? Color.red.opacity(0.1) : Color.red.opacity(0.05))
                                        .cornerRadius(10)
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.top, 10)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .animation(.easeInOut, value: isLoggedIn)
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            
            // ABOUT BUTTON
            .alert("WeatherFlight", isPresented: $showingAbout) {
                Button("Cerrar", role: .cancel) {}
            } message: {
                Text("Aplicación hecha por:\nDavid Emmanuel Santana Romero\nMauricio Alcántar Dueñas\nDiego Emilio Casta Valle\n Para la clase de Desarrollo para Plataformas Heterogéneas, 2025.\n\n\n© 2025 WeatherFlight. All rights reserved.")
            }
        }
    }
    
    private func generateProfileImage() {
        guard !username.isEmpty else { return }
        isLoadingImage = true
        
        let prompt = "portrait of a cat named \(username) in watercolor style"
        guard let url = URL(string: "https://image.pollinations.ai/prompt/\(prompt.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else {
            isLoadingImage = false
            return
        }
        
        // Pollinations API returns image directly from this URL, so we can assign it directly.
        // But per instructions, mock or do a call that returns JSON with URL.
        // Since Pollinations API is a simple GET image URL, we simulate a JSON response:
        
        // For demonstration, we'll simulate a network call with URLSession and decode a mock response.
        // But Pollinations API actually returns image directly at the URL.
        // So we simulate a JSON response:
        
        struct PollinationsResponse: Decodable {
            let url: String
        }
        
        // For the purpose of this task, we simulate a network call that returns JSON with the URL.
        // In real scenario, you would call your own backend or service.
        
        // Simulate JSON response with the image URL:
        let simulatedResponse = PollinationsResponse(url: url.absoluteString)
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            DispatchQueue.main.async {
                if let imageURL = URL(string: simulatedResponse.url) {
                    withAnimation(.easeInOut) {
                        self.profileImageURL = imageURL
                    }
                }
                self.isLoadingImage = false
            }
        }
    }

    // Método privado para cerrar sesión
    private func signOut() {
        // Reset all state to initial
        username = ""
        password = ""
        profileImageURL = nil
        isLoadingImage = false
        isLoggedIn = false
        print("Sesión cerrada")
    }
}

// Adding profile buttons
struct ProfileButton: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isPressed {
                        Color.gray.opacity(0.2)
                    } else {
                        Color(.systemBackground).opacity(0.7)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: isPressed)
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { isPressed = true }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
