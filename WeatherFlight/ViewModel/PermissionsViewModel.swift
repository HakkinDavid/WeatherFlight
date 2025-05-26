//
//  PermissionsViewModel.swift
//  WeatherFlight
//
//  Created by CETYS Universidad  on 14/05/25.
//


import Foundation
import Photos
import CoreLocation
import AVFoundation
import EventKit

class PermissionsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cameraGranted = false
    @Published var photoLibraryGranted = false
    @Published var locationGranted = false
    @Published var calendarGranted = false
    
    private let locationManager = CLLocationManager()
    
    var areAllPermissionsGranted: Bool {
        return locationGranted && calendarGranted
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
            }
        }
    }
    
    func requestPhotoLibraryAccess() {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if currentStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized || status == .limited)
                }
            }
        } else {
            self.photoLibraryGranted = (currentStatus == .authorized || currentStatus == .limited)
        }
    }
    func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
        }
    }
    
    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                self.calendarGranted = granted && error == nil
            }
        }
    }
}
