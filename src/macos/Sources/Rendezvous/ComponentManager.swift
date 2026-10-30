// ComponentManager.swift
// Manages spacecraft components and assembly

import Foundation

/// Component manager
class ComponentManager: ObservableObject {
    private var components: [ComponentProperties] = []
    private var assemblies: [SpacecraftAssembly] = []

    init() {
        loadComponents()
    }

    /// Load components from JSON files in the app's resource bundle
    func loadComponents() {
        let fileManager = FileManager.default
        guard let resourceURL = Bundle.main.resourceURL else {
            print("Error: no resource URL")
            createDefaultComponents()
            return
        }

        // ComponentData is bundled as a resource directory
        let componentDataURL = resourceURL.appendingPathComponent("ComponentData")

        do {
            let files = try fileManager.contentsOfDirectory(
                at: componentDataURL,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            let jsonFiles = files.filter { $0.pathExtension == "json" }

            if jsonFiles.isEmpty {
                print("No JSON files found in ComponentData, using defaults")
                createDefaultComponents()
                return
            }

            for fileURL in jsonFiles {
                let data = try Data(contentsOf: fileURL)
                let component = try JSONDecoder().decode(ComponentProperties.self, from: data)
                components.append(component)
            }
            print("Loaded \(components.count) components from JSON files")
        } catch {
            print("Error loading components: \(error)")
            createDefaultComponents()
        }
    }

    /// Create default components if loading fails
    func createDefaultComponents() {
        components = [
            ComponentProperties(
                id: "engine-001",
                type: .engine,
                name: "Chemical Rocket Engine",
                mass: 1500.0,
                width: 2.0,
                height: 3.0,
                thrust: 350000.0,
                maxThrust: 350000.0,
                burnTime: 180.0
            ),
            ComponentProperties(
                id: "fuel-tank-001",
                type: .fuelTank,
                name: "Standard Fuel Tank",
                mass: 800.0,
                width: 2.5,
                height: 4.0,
                fuelCapacity: 5000.0
            ),
            ComponentProperties(
                id: "solar-panel-001",
                type: .solarPanel,
                name: "Standard Solar Panel",
                mass: 200.0,
                width: 3.0,
                height: 1.5,
                powerOutput: 5000.0
            )
        ]
    }

    /// Get all available components
    func getAvailableComponents() -> [ComponentProperties] {
        return components
    }

    /// Create a new assembly
    func createAssembly() -> SpacecraftAssembly {
        let newAssembly = SpacecraftAssembly()
        assemblies.append(newAssembly)
        return newAssembly
    }

    /// Add component to assembly
    func addComponentToAssembly(
        component: ComponentProperties,
        position: CGPoint,
        rotation: Double = 0.0,
        parentId: String? = nil,
        to assembly: inout SpacecraftAssembly
    ) {
        let assemblyComponent = AssemblyComponent(
            id: UUID().uuidString,
            component: component,
            position: position,
            rotation: rotation,
            parentId: parentId
        )
        assembly.components.append(assemblyComponent)
    }

    /// Remove component from assembly
    func removeComponentFromAssembly(
        componentId: String,
        from assembly: inout SpacecraftAssembly
    ) {
        assembly.components.removeAll { $0.id == componentId }
    }

    /// Get all assemblies
    func getAssemblies() -> [SpacecraftAssembly] {
        return assemblies
    }

    /// Save assembly to file
    func saveAssembly(_ assembly: SpacecraftAssembly, to fileURL: URL) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(assembly)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving assembly: \(error)")
        }
    }

    /// Load assembly from file
    func loadAssembly(from fileURL: URL) -> SpacecraftAssembly? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let assembly = try decoder.decode(SpacecraftAssembly.self, from: data)
            assemblies.append(assembly)
            return assembly
        } catch {
            print("Error loading assembly: \(error)")
            return nil
        }
    }
}