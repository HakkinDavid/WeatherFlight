import SwiftUI
import CoreData

struct PermissionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var flightManager: FlightManager
    @StateObject private var permissionsViewModel = PermissionsViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false
    
    // Background animation
    @State private var currentTimeOfDay: TimeOfDay = .morning
    @State private var gradientColors: [Color] = TimeOfDay.morning.colors
    
    private let backgroundColor = Color(red: 0.98, green: 0.96, blue: 0.92)
    private let cardColor = Color(red: 0.95, green: 0.92, blue: 0.85)
    private let accentColor = Color(red: 0.8, green: 0.7, blue: 0.6)
    private let textColor = Color(red: 0.3, green: 0.25, blue: 0.2)
    private let shadowColor = Color(red: 0.7, green: 0.65, blue: 0.6).opacity(0.3)
    
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
                    backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 30) {
                        Spacer().frame(height: 50)
                        
                        Text("Weather Flight")
                            .font(.system(size: getSize() * 1.8, weight: .bold))
                            .foregroundColor(textColor)
                            .padding(.vertical, 10)
                        
                        Text("Por favor, acepta los permisos necesarios para continuar.")
                            .font(.system(size: getSize() * 1.2))
                            .multilineTextAlignment(.center)
                            .foregroundColor(textColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(cardColor)
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
                        
                        VStack(spacing: 25) {
                            if !permissionsViewModel.locationGranted {
                                VStack(spacing: 15) {
                                    Text("Permiso para la ubicación es necesario.")
                                        .foregroundColor(textColor)
                                        .font(.system(size: getSize()))
                                    
                                    Button("Solicitar acceso a la ubicación") {
                                        permissionsViewModel.requestLocationAccess()
                                    }
                                    .font(.system(size: getSize()))
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.9, green: 0.5, blue: 0.1))
                                    .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(cardColor)
                                .cornerRadius(15)
                                .shadow(color: shadowColor, radius: 5, x: 0, y: 3)
                            } else {
                                VStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: getSize() * 1.5))
                                        .foregroundColor(.green)
                                    
                                    Text("Ubicación habilitada")
                                        .foregroundColor(textColor)
                                        .font(.system(size: getSize()))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(cardColor)
                                .cornerRadius(15)
                                .shadow(color: shadowColor, radius: 5, x: 0, y: 3)
                            }
                            
                            if !permissionsViewModel.calendarGranted {
                                VStack(spacing: 15) {
                                    Text("Permiso para el calendario es necesario.")
                                        .foregroundColor(textColor)
                                        .font(.system(size: getSize()))
                                    
                                    Button("Solicitar acceso al calendario") {
                                        permissionsViewModel.requestCalendarAccess()
                                    }
                                    .font(.system(size: getSize()))
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.5, green: 0.2, blue: 0.8))
                                    .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(cardColor)
                                .cornerRadius(15)
                                .shadow(color: shadowColor, radius: 5, x: 0, y: 3)
                            } else {
                                VStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: getSize() * 1.5))
                                        .foregroundColor(.green)
                                    
                                    Text("Calendario habilitado")
                                        .foregroundColor(textColor)
                                        .font(.system(size: getSize()))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(cardColor)
                                .cornerRadius(15)
                                .shadow(color: shadowColor, radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding(.horizontal, 30)
                        /*
                        
                        Spacer()
                        
                        NavigationLink("Continuar", value: "ContentView")
                            .disabled(!permissionsViewModel.areAllPermissionsGranted)
                            .font(.system(size: getSize() * 1.3, weight: .bold))
                            .background(permissionsViewModel.areAllPermissionsGranted ? accentColor : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 50)
                         */
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
