import SwiftUI

struct PermissionsView: View {
    
    @StateObject private var permissionsViewModel = PermissionsViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    // Usamos UserDefaults para guardar si los permisos han sido concedidos previamente
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false
    
    var body: some View {
        if permissionsGranted {
            ContentView()
        } else {
            NavigationStack {
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
                        
                        Text("Por favor, acepta el permiso de ubicación.")
                            .font(.system(size: getSize()*0.9))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: getSize()) {
                            // Permiso de ubicación
                            if !permissionsViewModel.locationGranted {
                                Text("Permiso para la ubicación es necesario.")
                                    .foregroundColor(.red)
                                    .font(.system(size: getSize()))
                                Button("Solicitar acceso a la ubicación") {
                                    permissionsViewModel.requestLocationAccess()
                                }
                                .font(.system(size: getSize()))
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                            } else {
                                Text("Gracias, ubicación habilitada.")
                                    .foregroundColor(.green)
                                    .font(.system(size: getSize()))
                            }
                        }
                        .padding(.horizontal, getSize())
                        
                        Spacer()
                        
                        NavigationLink("Continuar", value: "ContentView")
                            .disabled(!permissionsViewModel.areAllPermissionsGranted)
                            .font(.system(size: getSize()*1.25))
                            .foregroundColor(.white)
                            .padding()
                            .background(permissionsViewModel.areAllPermissionsGranted ? Color.orange : Color.gray)
                            .cornerRadius(10)
                            .padding(.bottom, 50)
                            .opacity(permissionsViewModel.areAllPermissionsGranted ? 1 : 0.5)
                    }
                    .navigationDestination(for: String.self) { value in
                        if value == "ContentView" {
                            ContentView()
                        }
                    }
                }
            }
            .onChange(of: permissionsViewModel.areAllPermissionsGranted) { newValue in
                // Si todos los permisos son concedidos, guardamos en UserDefaults
                if newValue {
                    permissionsGranted = true
                }
            }
        }
    }
    func getSize() -> CGFloat {
        switch sizeCategory {
        case .extraSmall, .small:
            return 14
        case .medium:
            return 20
        case .large:
            return 24
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge:
            return 36
        default:
            return 20
        }
      }
}

#Preview {
    PermissionsView()
}
