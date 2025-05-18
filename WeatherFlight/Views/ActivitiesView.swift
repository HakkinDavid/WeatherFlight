//
//  ActivitiesView.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//


import SwiftUI

struct ActivitiesView: View {
    // TODO: Más adelante podemos pasar ciudad y clima
    @State private var selectedActivities: [Activity] = []
    @State private var showFavoritesOnly = false

    let activities = sampleActivities

    var body: some View {
        NavigationView {
            List {
                Toggle("Mostrar solo favoritas", isOn: $showFavoritesOnly)

                ForEach(filteredActivities) { activity in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(activity.name).font(.headline)
                            Text(activity.description).font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            toggleActivity(activity)
                        }) {
                            Image(systemName: selectedActivities.contains(activity) ? "checkmark.circle.fill" : "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Actividades")
        }
    }

    var filteredActivities: [Activity] {
        showFavoritesOnly ? selectedActivities : activities
    }

    func toggleActivity(_ activity: Activity) {
        if selectedActivities.contains(activity) {
            selectedActivities.removeAll { $0.id == activity.id }
        } else {
            selectedActivities.append(activity)
        }
    }
}
