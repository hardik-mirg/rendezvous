// GameView.swift
// Main gameplay view with orbital canvas and overlay HUD

import SwiftUI

enum GameMode: String {
    case launchPad
    case assembly
    case flight
}

struct GameView: View {
    @StateObject private var physics = PhysicsEngine()
    @StateObject private var camera = Camera()
    @State private var gameMode: GameMode = .launchPad
    @State private var throttle: Double = 0.0
    @State private var timeScale: Double = 1.0
    @State private var assembly: SpacecraftAssembly? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch gameMode {
            case .launchPad:
                Text("Launch Pad")
                    .foregroundColor(.white)
                    .onTapGesture {
                        gameMode = .assembly
                    }
            case .assembly:
                Text("Assembly View")
                    .foregroundColor(.white)
                    .onTapGesture {
                        gameMode = .launchPad
                    }
            case .flight:
                Text("Flight View")
                    .foregroundColor(.white)
                    .onTapGesture {
                        gameMode = .launchPad
                    }
            }
        }
        .onAppear {
            startGameLoop()
        }
    }

    private func startGameLoop() {
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if gameMode == .flight {
                    physics.update(deltaTime: 1.0/60.0)

                    // Update camera to follow spacecraft
                    let worldX = cos(physics.angle) * (PhysicsEngine.EarthRadius + physics.altitude)
                    let worldY = sin(physics.angle) * (PhysicsEngine.EarthRadius + physics.altitude)
                    camera.lookAt(worldX, worldY)

                    // Check landing
                    if physics.altitude <= 0 && physics.verticalSpeed < 5 {
                        print("Landed!")
                    }
                }
            }
        }
    }

    private func applyAssemblyToPhysics(_ assembly: SpacecraftAssembly) {
        physics.dryMass = assembly.totalMass
        physics.thrust = assembly.totalThrust
        physics.maxFuel = assembly.totalFuelCapacity
        physics.fuel = assembly.totalFuelCapacity
    }
}