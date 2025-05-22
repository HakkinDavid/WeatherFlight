import SwiftUI
import CoreData

struct PermissionsView: View {
    @EnvironmentObject var flightManager: FlightManager
    @StateObject private var permissionsViewModel = PermissionsViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false
    
    // Background animation
    @State private var currentTimeOfDay: TimeOfDay = .morning
    @State private var gradientColors: [Color] = TimeOfDay.morning.colors
    
    enum TimeOfDay: CaseIterable {
        case morning, afternoon, night
        
        var colors: [Color] {
            switch self {
            case .morning:
                return [Color(red: 0.95, green: 0.85, blue: 0.7),
                        Color(red: 0.8, green: 0.9, blue: 1.0)]
            case .afternoon:
                return [Color(red: 0.98, green: 0.7, blue: 0.4),
                        Color(red: 0.98, green: 0.6, blue: 0.25),
                        Color(red: 0.4, green: 0.6, blue: 0.9)]
            case .night:
                return [Color(red: 0.1, green: 0.1, blue: 0.3),
                        Color(red: 0.3, green: 0.3, blue: 0.6)]
            }
        }
        
        var duration: Double {
            switch self {
            case .morning: return 8.0
            case .afternoon: return 6.0
            case .night: return 10.0
            }
        }
    }
    
    var body: some View {
        if permissionsGranted {
            ContentView()
        } else {
            NavigationStack {
                ZStack {
                    // Changing background (Morning, evening, night)
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .animation(
                        .easeInOut(duration: 3.0),
                        value: gradientColors
                    )
                    
                    VStack(spacing: 30) {
                        Spacer().frame(height: 50)
                        
                        Text("Weather Flight")
                            .font(.system(size: getSize() * 1.8, weight: .bold))
                            .foregroundColor(currentTimeOfDay == .night ? .white : .black)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 3)
                            .padding(.vertical, 20)
                        
                        Text("Por favor, acepta el permiso de ubicación.")
                            .font(.system(size: getSize() * 1.2))
                            .multilineTextAlignment(.center)
                            .foregroundColor(currentTimeOfDay == .night ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(currentTimeOfDay == .night ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        
                        VStack(spacing: 25) {
                            if !permissionsViewModel.locationGranted {
                                VStack(spacing: 15) {
                                    Text("Permiso para la ubicación es necesario.")
                                        .foregroundColor(currentTimeOfDay == .night ? .white : .black)
                                        .font(.system(size: getSize()))
                                    
                                    Button("Solicitar acceso a la ubicación") {
                                        permissionsViewModel.requestLocationAccess()
                                    }
                                    .font(.system(size: getSize()))
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.9, green: 0.5, blue: 0.1))
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 3)
                                }
                            } else {
                                VStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: getSize() * 1.5))
                                        .foregroundColor(.green)
                                    
                                    Text("Ubicación habilitada")
                                        .foregroundColor(currentTimeOfDay == .night ? .white : .black)
                                        .font(.system(size: getSize()))
                                }
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        NavigationLink("Continuar", value: "ContentView")
                            .disabled(!permissionsViewModel.areAllPermissionsGranted)
                            .font(.system(size: getSize() * 1.3, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(
                                permissionsViewModel.areAllPermissionsGranted ?
                                LinearGradient(gradient: Gradient(colors: [.orange, .yellow]),
                                              startPoint: .top, endPoint: .bottom) :
                                LinearGradient(gradient: Gradient(colors: [.gray, .gray.opacity(0.7)]),
                                              startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.bottom, 50)
                    }
                    .navigationDestination(for: String.self) { value in
                        if value == "ContentView" {
                            ContentView()
                        }
                    }
                }
            }
            .onAppear {
                startTimeOfDayCycle()
            }
            .onChange(of: permissionsViewModel.areAllPermissionsGranted) { newValue in
                if newValue {
                    permissionsGranted = true
                }
            }
        }
    }
    
    // Switch between "Times Of Day"
    private func startTimeOfDayCycle() {
        let allTimes = TimeOfDay.allCases
        guard let currentIndex = allTimes.firstIndex(of: currentTimeOfDay) else { return }
        
        let nextIndex = (currentIndex + 1) % allTimes.count
        let nextTime = allTimes[nextIndex]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + currentTimeOfDay.duration) {
            withAnimation {
                self.currentTimeOfDay = nextTime
                self.gradientColors = nextTime.colors
            }
            self.startTimeOfDayCycle()
        }
    }
    
    func getSize() -> CGFloat {
        switch sizeCategory {
        case .extraSmall, .small: return 14
        case .medium: return 16
        case .large: return 18
        case .extraLarge: return 22
        case .extraExtraLarge: return 26
        case .extraExtraExtraLarge: return 30
        default: return 18
        }
    }
}

#Preview {
    PermissionsView()
        .environmentObject(FlightManager(context: PersistenceController().container.viewContext))
}
