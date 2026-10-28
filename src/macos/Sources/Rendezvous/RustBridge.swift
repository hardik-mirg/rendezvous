// RustBridge.swift
// Simple wrapper for Rust calculations

import Foundation

/// Wrapper for Rust calculations
struct RustBridge {
    // Calculate Hohmann transfer between two circular orbits
    static func calculateHohmannTransfer(orbitRadius1: Double, orbitRadius2: Double) -> (deltaV1: Double, deltaV2: Double, transferTime: Double) {
        var deltaV1: Double = 0.0
        var deltaV2: Double = 0.0
        var transferTime: Double = 0.0

        // Use the correct orbital mechanics equations
        let g = 6.67430e-11
        let earthMass = 5.972e24
        let semiMajorAxis = (orbitRadius1 + orbitRadius2) / 2.0

        // Initial circular orbit velocity
        let v1 = sqrt(g * earthMass / orbitRadius1)

        // Transfer orbit velocity at periapsis
        let vTransferPeriapsis = sqrt(g * earthMass * (2.0 / orbitRadius1 - 1.0 / semiMajorAxis))

        // Delta-v 1
        deltaV1 = vTransferPeriapsis - v1

        // Final circular orbit velocity
        let v2 = sqrt(g * earthMass / orbitRadius2)

        // Transfer orbit velocity at apoapsis
        let vTransferApoapsis = sqrt(g * earthMass * (2.0 / orbitRadius2 + 1.0 / semiMajorAxis))

        // Delta-v 2
        deltaV2 = v2 - vTransferApoapsis

        // Transfer time (half the period of the transfer orbit)
        transferTime = Double.pi * pow(semiMajorAxis, 1.5) / sqrt(g * earthMass)

        return (deltaV1, deltaV2, transferTime)
    }

    // Update spacecraft state
    static func updateSpacecraftState(
        currentAltitude: Double,
        currentSpeed: Double,
        currentAngle: Double,
        thrust: Double,
        mass: Double,
        deltaT: Double
    ) -> (altitude: Double, speed: Double, orbitDescription: String) {
        var outAltitude: Double = currentAltitude
        var outSpeed: Double = currentSpeed + (thrust / mass) * deltaT
        let orbitDescription = outAltitude > 6371000.0 * 0.1 ? "Low Earth Orbit" : "Suborbital"

        return (outAltitude, outSpeed >= 0.0 ? outSpeed : 0.0, orbitDescription)
    }

    // Get orbital parameters
    static func getOrbitalParameters(altitude: Double) -> (velocity: Double, periodMinutes: Double, description: String) {
        let earthRadius = 6371000.0
        let orbitalRadius = earthRadius + altitude
        let g = 6.67430e-11
        let earthMass = 5.972e24
        let velocity = sqrt(g * earthMass / orbitalRadius)
        let period = 2.0 * Double.pi * orbitalRadius / velocity
        let periodMinutes = period / 60.0
        let description = "\(String(format: "%.0f km orbit", orbitalRadius / 1000.0))"

        return (velocity, periodMinutes, description)
    }
}