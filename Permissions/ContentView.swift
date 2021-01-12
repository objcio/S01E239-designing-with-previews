//
//  ContentView.swift
//  Permissions
//
//  Created by Florian Kugler on 04-01-2021.
//

import SwiftUI
import AVFoundation

extension Permissions.Device {
    var icon: Image {
        switch self {
        case .camera: return Image(systemName: "camera")
        case .microphone: return Image(systemName: "mic")
        case .screen: return Image(systemName: "rectangle.on.rectangle")
        }
    }
}

struct Icon: View {
    var device: Permissions.Device
    var isAuthorized: Bool
    
    var body: some View {
        device.icon
            .overlay(Group {
                if isAuthorized {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 16, height: 16)
                        .overlay(Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                        )
                        .offset(x: 8, y: -8)
                }
            }, alignment: .topTrailing)
    }
}

extension Permissions.Device: Identifiable {
    var id: Self { self }
}

struct PermissionsView: View {
    var currentDevice: Permissions.Device
    var status: [Permissions.Device: AVAuthorizationStatus]
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 30) {
                ForEach([Permissions.Device.camera, .microphone, .screen]) { dev in
                    Icon(device: dev, isAuthorized: status[dev] == .authorized)
                        .opacity(currentDevice == dev ? 1 : 0.6)
                }
            }
            .font(.largeTitle)
            Button("Authorize") {
                Permissions.global.authorize(currentDevice)
            }
        }
        .padding(30)
    }
}

struct ContentView: View {
    @ObservedObject var permissions = Permissions.global
    
    var body: some View {
        PermissionsView(currentDevice: permissions.currentDevice, status: permissions.status)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView(currentDevice: .camera, status: [:])
        PermissionsView(currentDevice: .microphone, status: [.camera: .authorized])
        PermissionsView(currentDevice: .screen, status:
                            [.camera: .authorized, .microphone: .authorized])
            .preferredColorScheme(.light)
    }
}
