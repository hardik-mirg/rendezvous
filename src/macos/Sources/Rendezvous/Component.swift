// Component.swift
// Spacecraft component model and types

import Foundation
import SwiftUI

/// Spacecraft component types
enum ComponentType: String, CaseIterable, Identifiable, Codable {
    case engine
    case fuelTank
    case solarPanel
    case landingGear
    case cockpit
    case battery
    case antenna
    case reactionWheel
    case separator

    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .engine: return "Engine"
        case .fuelTank: return "Fuel Tank"
        case .solarPanel: return "Solar Panel"
        case .landingGear: return "Landing Gear"
        case .cockpit: return "Cockpit"
        case .battery: return "Battery"
        case .antenna: return "Antenna"
        case .reactionWheel: return "Reaction Wheel"
        case .separator: return "Stage Separator"
        }
    }

    var iconName: String {
        switch self {
        case .engine: return "bolt"
        case .fuelTank: return "drop"
        case .solarPanel: return "solarpanel"
        case .landingGear: return "gear"
        case .cockpit: return "person"
        case .battery: return "battery"
        case .antenna: return "radio"
        case .reactionWheel: return "circle"
        case .separator: return "arrow.up.arrow.down"
        }
    }

    var color: Color {
        switch self {
        case .engine: return .red
        case .fuelTank: return .blue
        case .solarPanel: return .yellow
        case .landingGear: return .green
        case .cockpit: return .purple
        case .battery: return .orange
        case .antenna: return .cyan
        case .reactionWheel: return .pink
        case .separator: return .gray
        }
    }
}

/// Spacecraft component properties
struct ComponentProperties: Identifiable, Codable {
    let id: String
    let type: ComponentType
    let name: String
    let mass: Double // kg
    let width: Double // meters
    let height: Double // meters
    let thrust: Double? // N (nil for non-engine components)
    let fuelCapacity: Double? // liters (nil for non-fuel components)
    let powerOutput: Double? // Watts (nil for non-solar components)
    let maxThrust: Double? // N (for engines)
    let burnTime: Double? // seconds (for engines)
    let landingGear: Bool // for landing gear
    let cockpitCapacity: Int? // for cockpit
    let batteryCapacity: Double? // kWh (for batteries)
    let antennaRange: Double? // km (for antennas)
    let reactionWheelTorque: Double? // Nm (for reaction wheels)

    init(
        id: String,
        type: ComponentType,
        name: String,
        mass: Double,
        width: Double,
        height: Double,
        thrust: Double? = nil,
        fuelCapacity: Double? = nil,
        powerOutput: Double? = nil,
        maxThrust: Double? = nil,
        burnTime: Double? = nil,
        landingGear: Bool = false,
        cockpitCapacity: Int? = nil,
        batteryCapacity: Double? = nil,
        antennaRange: Double? = nil,
        reactionWheelTorque: Double? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.mass = mass
        self.width = width
        self.height = height
        self.thrust = thrust
        self.fuelCapacity = fuelCapacity
        self.powerOutput = powerOutput
        self.maxThrust = maxThrust
        self.burnTime = burnTime
        self.landingGear = landingGear
        self.cockpitCapacity = cockpitCapacity
        self.batteryCapacity = batteryCapacity
        self.antennaRange = antennaRange
        self.reactionWheelTorque = reactionWheelTorque
    }
}

/// Spacecraft assembly component
struct AssemblyComponent: Identifiable, Codable {
    var id: String
    let component: ComponentProperties
    var position: CGPoint
    var rotation: Double // degrees
    let parentId: String? // nil for root components

    init(id: String, component: ComponentProperties, position: CGPoint, rotation: Double = 0.0, parentId: String? = nil) {
        self.id = id
        self.component = component
        self.position = position
        self.rotation = rotation
        self.parentId = parentId
    }
}

/// Spacecraft assembly
struct SpacecraftAssembly: Codable {
    var components: [AssemblyComponent]
    var totalMass: Double { components.reduce(0) { $0 + $1.component.mass } }
    var totalThrust: Double { components.compactMap { $0.component.thrust }.reduce(0, +) }
    var totalFuelCapacity: Double { components.compactMap { $0.component.fuelCapacity }.reduce(0, +) }
    var totalPowerOutput: Double { components.compactMap { $0.component.powerOutput }.reduce(0, +) }

    init(components: [AssemblyComponent] = []) {
        self.components = components
    }
}

