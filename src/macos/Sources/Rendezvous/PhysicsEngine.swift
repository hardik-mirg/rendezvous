// PhysicsEngine.swift
// Core orbital physics simulation

import Foundation
import SwiftUI

/// Main physics engine - handles all orbital mechanics
class PhysicsEngine: ObservableObject {
    // MARK: - Constants
    static let G: Double = 6.67430e-11
    static let EarthMass: Double = 5.972e24
    static let EarthRadius: Double = 6371000.0
    static let GM: Double = G * EarthMass

    // MARK: - State
    @Published var altitude: Double = 400000.0
    @Published var angle: Double = 0.0
    @Published var speed: Double = 0.0
    @Published var verticalSpeed: Double = 0.0
    @Published var heading: Double = 0.0 // degrees from prograde

    @Published var fuel: Double = 5000.0
    @Published var maxFuel: Double = 5000.0
    @Published var dryMass: Double = 2000.0
    @Published var thrust: Double = 400000.0

    // MARK: - Controls
    var throttle: Double = 0.0
    var timeScale: Double = 1.0

    // MARK: - Computed Properties
    var totalMass: Double { dryMass + fuel }
    var orbitalRadius: Double { PhysicsEngine.EarthRadius + altitude }

    var circularVelocity: Double {
        sqrt(PhysicsEngine.GM / orbitalRadius)
    }

    var orbitalPeriod: Double {
        2.0 * .pi * orbitalRadius / speed
    }

    var semiMajorAxis: Double {
        let v2 = speed * speed + verticalSpeed * verticalSpeed
        return 1.0 / (2.0/orbitalRadius - v2/PhysicsEngine.GM)
    }

    var eccentricity: Double {
        let r = orbitalRadius
        let v2 = speed * speed + verticalSpeed * verticalSpeed
        let h = r * speed
        let mu = PhysicsEngine.GM
        let e2 = 1.0 + (2.0 * h * h * (v2 - 2.0 * mu/r)) / (mu * mu)
        return sqrt(max(0, e2))
    }

    var periapsis: Double {
        semiMajorAxis * (1.0 - eccentricity) - PhysicsEngine.EarthRadius
    }

    var apoapsis: Double {
        semiMajorAxis * (1.0 + eccentricity) - PhysicsEngine.EarthRadius
    }

    var thrustToWeight: Double {
        let r = orbitalRadius
        let g = PhysicsEngine.GM / (r * r)
        return totalMass > 0 ? thrust / (totalMass * g) : 0
    }

    var isSuborbital: Bool { altitude < 10000 }
    var isOrbiting: Bool { !isSuborbital && speed > circularVelocity * 0.5 }

    var orbitType: String {
        if altitude < 10000 { return "Suborbital" }
        if eccentricity < 0.01 { return "Circular" }
        if eccentricity < 0.3 { return "Elliptical" }
        if eccentricity < 1.0 { return "Highly Elliptical" }
        return "Escape Trajectory"
    }

    // MARK: - Init
    init(initialAltitude: Double = 400000.0) {
        reset(to: initialAltitude)
    }

    // MARK: - Reset
    func reset(to altitude: Double = 400000.0) {
        self.altitude = altitude
        self.angle = 0
        self.speed = sqrt(PhysicsEngine.GM / (PhysicsEngine.EarthRadius + altitude))
        self.verticalSpeed = 0
        self.heading = 0
        self.fuel = 5000.0
        self.maxFuel = 5000.0
        self.dryMass = 2000.0
        self.thrust = 400000.0
        self.throttle = 0
        self.timeScale = 1
    }

    // MARK: - Update
    func update(deltaTime: Double) {
        let dt = deltaTime * timeScale

        // Current orbital radius
        let r = orbitalRadius

        // Gravitational acceleration (towards center)
        let gMagnitude = PhysicsEngine.GM / (r * r)

        // Thrust acceleration
        let thrustAccel = throttle * thrust / totalMass

        // Decompose thrust: heading 0 = prograde (tangential), ±90 = radial
        let headingRad = heading * .pi / 180.0
        let thrustTangential = thrustAccel * cos(headingRad)
        let thrustRadial = thrustAccel * sin(headingRad)

        // Update velocities
        let newVerticalSpeed = verticalSpeed + (thrustRadial - gMagnitude) * dt
        let newSpeed = speed + thrustTangential * dt

        // Update position
        let newAltitude = altitude + newVerticalSpeed * dt
        let newAngle = angle + (newSpeed / r) * dt

        // Consume fuel
        if throttle > 0 && fuel > 0 {
            let fuelFlowRate = (throttle * thrust) / 3000.0 // ~300s Isp
            fuel = max(0, fuel - fuelFlowRate * dt)
        }

        // Update state
        self.verticalSpeed = newVerticalSpeed
        self.speed = newSpeed
        self.altitude = newAltitude
        self.angle = newAngle

        // Prevent going underground
        if altitude < 0 {
            altitude = 0
            verticalSpeed = 0
            if speed < 100 { speed = 0 }
        }
    }

    // MARK: - Input Handling
    func pitchUp() { heading = min(90, heading + 1) }
    func pitchDown() { heading = max(-90, heading - 1) }
    func yawLeft() { heading = max(-90, heading - 0.5) }
    func yawRight() { heading = min(90, heading + 0.5) }
    func setThrottle(_ value: Double) { throttle = max(0, min(1, value)) }
    func setTimeScale(_ value: Double) { timeScale = max(1, min(100, value)) }
}
