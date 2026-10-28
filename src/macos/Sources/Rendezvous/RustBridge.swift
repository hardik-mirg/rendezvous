// RustBridge.swift
// Wrapper for Rust FFI using a simpler approach

import Foundation

/// Wrapper around Rust FFI functions for orbital mechanics
struct RustBridge {

    // Load the Rust dynamic library
    private static let library = dlopen("librendezvous_core.dylib", RTLD_LAZY)

    /// Calculate Hohmann transfer between two circular orbits
    static func calculateHohmannTransfer(orbitRadius1: Double, orbitRadius2: Double) -> (deltaV1: Double, deltaV2: Double, transferTime: Double) {
        var deltaV1: Double = 0.0
        var deltaV2: Double = 0.0
        var transferTime: Double = 0.0

        let funcPtr = unsafeBitCast(
            dlsym(library, "rendezvous_hohmann_transfer"),
            to: UnsafeRawPointer<(Double, Double, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>) -> ()>.self
        )
        funcPtr(
            orbitRadius1,
            orbitRadius2,
            &deltaV1,
            &deltaV2,
            &transferTime
        )

        return (deltaV1, deltaV2, transferTime)
    }

    /// Update spacecraft state based on thrust and time
    static func updateSpacecraftState(
        altitude: Double,
        speed: Double,
        angle: Double,
        thrust: Double,
        mass: Double,
        deltaT: Double
    ) -> (altitude: Double, speed: Double, flightPathAngle: Double, availableDeltaV: Double, thrustToWeight: Double, orbitDescription: String) {
        var outAltitude: Double = 0.0
        var outSpeed: Double = 0.0
        var outFlightPathAngle: Double = 0.0
        var outAvailableDeltaV: Double = 0.0
        var outThrustToWeight: Double = 0.0

        let funcPtr = unsafeBitCast(
            dlsym(library, "rendezvous_update_spacecraft_state"),
            to: UnsafeRawPointer<(Double, Double, Double, Double, Double, Double, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>) -> UnsafeMutablePointer<Int8>>.self
        )
        let ptr = funcPtr(
            altitude,
            speed,
            angle,
            thrust,
            mass,
            deltaT,
            &outAltitude,
            &outSpeed,
            &outFlightPathAngle,
            &outAvailableDeltaV,
            &outThrustToWeight
        )

        let orbitDescription: String
        if ptr != nil {
            orbitDescription = String(cString: ptr!)
            let freeFuncPtr = unsafeBitCast(
                dlsym(library, "rendezvous_free_string"),
                to: UnsafeRawPointer<(UnsafeMutablePointer<Int8>) -> Void>.self
            )
            freeFuncPtr(ptr!)
        } else {
            orbitDescription = "Unknown"
        }

        return (outAltitude, outSpeed, outFlightPathAngle, outAvailableDeltaV, outThrustToWeight, orbitDescription)
    }

    /// Get orbital parameters for display
    static func getOrbitalParameters(altitude: Double) -> (velocity: Double, periodMinutes: Double, description: String) {
        var outVelocity: Double = 0.0
        var outPeriodMinutes: Double = 0.0

        let funcPtr = unsafeBitCast(
            dlsym(library, "rendezvous_get_orbital_parameters"),
            to: UnsafeRawPointer<(Double, UnsafeMutablePointer<Double>, UnsafeMutablePointer<Double>) -> UnsafeMutablePointer<Int8>>.self
        )
        let ptr = funcPtr(
            altitude,
            &outVelocity,
            &outPeriodMinutes
        )

        let description: String
        if ptr != nil {
            description = String(cString: ptr!)
            let freeFuncPtr = unsafeBitCast(
                dlsym(library, "rendezvous_free_string"),
                to: UnsafeRawPointer<(UnsafeMutablePointer<Int8>) -> Void>.self
            )
            freeFuncPtr(ptr!)
        } else {
            description = "Unknown"
        }

        return (outVelocity, outPeriodMinutes, description)
    }
}