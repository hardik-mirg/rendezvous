// SwiftUI entry point for the Rendezvous macOS application
// This will integrate with the Rust core library

import SwiftUI

@main
struct RendezvousApp {
    static func main() {
        print("Rendezvous macOS Application Starting...")
        print("Core orbital mechanics library loaded from Rust")

        // Initialize the UI and game state
        NSApplication.shared.run()
    }
}

// Main content view for the Rendezvous application
struct ContentView: View {
    // Game state properties
    @State private var rocketSpeed: Double = 0.0
    @State private var rocketAltitude: Double = 0.0
    @State private var rocketAngle: Double = 0.0
    @State private var deltaV: Double = 0.0
    @State private var thrustToWeight: Double = 0.0
    @State private var currentOrbit: String = "Low Earth Orbit (LEO)"
    @State private var orbitalPeriod: Double = 0.0
    @State private var semiMajorAxis: Double = 0.0
    @State private var eccentricity: Double = 0.0
    @State private var periapsis: Double = 0.0
    @State private var apoapsis: Double = 0.0

    // Mock data - will be replaced with Rust integration
    let earthRadius: Double = 6371000.0

    var body: some View {
        VStack(spacing: 20) {
            // Game title
            HStack {
                Text("RENDEZVOUS")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.cyan)
                Text("v0.1.0")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            // Orbital status card
            VStack(spacing: 15) {
                HStack {
                    Text("ORBITAL STATUS")
                        .font(.headline)
                        .foregroundColor(.green)
                    Spacer()
                    Text(currentOrbit)
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }

                // Altitude display
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.green)
                    Text("Altitude")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f m", rocketAltitude))
                        .font(.system(size: 18))
                        .foregroundColor(.green)
                }

                // Speed display
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundColor(.blue)
                    Text("Speed")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f m/s", rocketSpeed))
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                }

                // Angle display
                HStack {
                    Image(systemName: "arrow.left.arrow.right")
                        .foregroundColor(.purple)
                    Text("Angle")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f°", rocketAngle))
                        .font(.system(size: 18))
                        .foregroundColor(.purple)
                }

                // ΔV display
                HStack {
                    Image(systemName: "arrow.turn.up.right")
                        .foregroundColor(.orange)
                    Text("ΔV Available")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f m/s", deltaV))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }

                // Thrust-to-Weight ratio
                HStack {
                    Image(systemName: "scale.3d")
                        .foregroundColor(.red)
                    Text("Thrust/Weight")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.1f:1", thrustToWeight))
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding(.horizontal, 20)

            // Orbit information card
            VStack(spacing: 15) {
                HStack {
                    Text("ORBIT INFO")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Spacer()
                }

                HStack {
                    Text("Orbital Period")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.1f min", orbitalPeriod))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }

                HStack {
                    Text("Semi-Major Axis")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f km", semiMajorAxis))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }

                HStack {
                    Text("Eccentricity")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.3f", eccentricity))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }

                HStack {
                    Text("Periapsis")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f km", periapsis))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }

                HStack {
                    Text("Apoapsis")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.0f km", apoapsis))
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding(.horizontal, 20)

            // Spacecraft building section
            VStack(spacing: 15) {
                HStack {
                    Text("SPACECRAFT ASSEMBLY")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Spacer()
                }

                HStack(spacing: 10) {
                    // Engine block
                    VStack {
                        Image(systemName: "bolt")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                        Text("Engine")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 80)
                    .background(Color.gray)
                    .cornerRadius(8)

                    // Fuel tank block
                    VStack {
                        Image(systemName: "drop")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        Text("Fuel")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 80)
                    .background(Color.gray)
                    .cornerRadius(8)

                    // Solar panel block
                    VStack {
                        Image(systemName: "solarpanel")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                        Text("Panel")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 80)
                    .background(Color.gray)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                // Build button
                Button(action: {
                    print("Opening Spacecraft Builder...")
                    // TODO: Implement spacecraft building UI
                }) {
                    HStack {
                        Image(systemName: "hammer")
                            .foregroundColor(.white)
                        Text("OPEN BUILDER")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }

            // Controls section
            VStack(spacing: 15) {
                HStack {
                    Text("CONTROLS")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }

                HStack(spacing: 20) {
                    ControlButton(image: "arrow.up.arrow.down", action: { print("Thrust Forward") })
                    ControlButton(image: "arrow.left.arrow.right", action: { print("Yaw Left") })
                    ControlButton(image: "arrow.up", action: { print("Pitch Up") })
                }
                .padding(.horizontal, 20)

                HStack(spacing: 20) {
                    ControlButton(image: "arrow.down", action: { print("Thrust Reverse") })
                    ControlButton(image: "arrow.left.arrow.right", action: { print("Yaw Right") })
                    ControlButton(image: "arrow.down", action: { print("Pitch Down") })
                }
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .frame(width: 500, height: 700)
        .background(Color.black)
        .onAppear {
            // Initialize game state
            resetGameState()
        }
    }

    // Reset game state with initial values
    func resetGameState() {
        rocketSpeed = 0.0
        rocketAltitude = 100000.0 // Start at 100km altitude
        rocketAngle = 0.0
        deltaV = 9200.0 // Typical Earth orbit ΔV
        thrustToWeight = 1.2
        currentOrbit = "Low Earth Orbit (LEO)"
        orbitalPeriod = 88.0 // ~90 minutes for LEO
        semiMajorAxis = 7371000.0 // 100km altitude
        eccentricity = 0.0
        periapsis = 7371000.0
        apoapsis = 7371000.0
    }

    // Update game state using Rust calculations
    func updateGameState() {
        let altitude = rocketAltitude
        let (velocity, period, orbitDescription) = RustBridge.getOrbitalParameters(altitude: altitude)
        let semiMajorAxis = altitude + 6371000.0
        let eccentricity = 0.0
        let periapsis = semiMajorAxis
        let apoapsis = semiMajorAxis

        // Update UI state
        rocketSpeed = velocity
        orbitalPeriod = period
        currentOrbit = orbitDescription
        self.semiMajorAxis = semiMajorAxis
        self.eccentricity = eccentricity
        self.periapsis = periapsis
        self.apoapsis = apoapsis
    }
}

// Reusable control button view
struct ControlButton: View {
    let image: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: image)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.gray)
                .cornerRadius(8)
        }
    }
}