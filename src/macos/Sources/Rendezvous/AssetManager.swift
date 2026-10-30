// AssetManager.swift
// Loads and manages SVG/PNG assets from Figma exports

import Foundation
import SwiftUI
import AppKit

class AssetManager: ObservableObject {
    static let shared = AssetManager()

    @Published var earthSVG: NSImage?
    @Published var moonSVG: NSImage?
    @Published var sunSVG: NSImage?
    @Published var launchPadSVG: NSImage?
    @Published var rocketParts: [String: NSImage] = [:]
    @Published var uiIcons: [String: NSImage] = [:]

    private init() {
        loadAssets()
    }

    private func loadAssets() {
        // Load SVG assets from the app bundle
        let resourceURL = Bundle.main.resourceURL

        // Earth
        if let url = resourceURL?.appendingPathComponent("Assets/earth.svg") {
            earthSVG = loadSVG(from: url)
        }

        // Moon
        if let url = resourceURL?.appendingPathComponent("Assets/moon.svg") {
            moonSVG = loadSVG(from: url)
        }

        // Sun
        if let url = resourceURL?.appendingPathComponent("Assets/sun.svg") {
            sunSVG = loadSVG(from: url)
        }

        // Launch pad
        if let url = resourceURL?.appendingPathComponent("Assets/launchpad.svg") {
            launchPadSVG = loadSVG(from: url)
        }

        // Load rocket parts
        loadRocketParts()

        // Load UI icons
        loadUIIcons()
    }

    private func loadSVG(from url: URL) -> NSImage? {
        do {
            let data = try Data(contentsOf: url)
            // Try to load as SVG
            if let image = loadSVGData(data) {
                return image
            }
            // Fallback to PNG
            if let image = NSImage(data: data) {
                return image
            }
        } catch {
            print("Failed to load SVG from: \(url) - Error: \(error)")
        }
        return nil
    }

    private func loadSVGData(_ data: Data) -> NSImage? {
        // For production, consider using a proper SVG renderer like SwiftSVG
        // This is a simplified placeholder implementation
        guard let svgString = String(data: data, encoding: .utf8) else { return nil }

        // Extract width and height from SVG
        let width = extractSVGDimension(svgString, attribute: "width") ?? 512
        let height = extractSVGDimension(svgString, attribute: "height") ?? 512

        // Create a placeholder image
        let image = NSImage(size: NSSize(width: width, height: height))
        image.lockFocus()

        // Draw a colored rectangle as placeholder
        // In production, you would render actual SVG paths here
        NSColor.blue.setFill()
        NSRect(x: 0, y: 0, width: width, height: height).fill()

        image.unlockFocus()
        return image
    }

    private func extractSVGDimension(_ svg: String, attribute: String) -> Double? {
        let pattern = "\(attribute)=\"([0-9.]+)\""
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let match = regex?.firstMatch(in: svg, options: [], range: NSRange(location: 0, length: svg.utf16.count)) else {
            return nil
        }
        let range = match.range(at: 1)
        guard let rangeSubstring = Range(range, in: svg) else { return nil }
        return Double(String(svg[rangeSubstring]))
    }

    private func loadRocketParts() {
        let partNames = ["engine", "fuelTank", "cockpit", "solarPanel", "landingGear", "battery", "antenna", "reactionWheel", "separator"]

        for name in partNames {
            if let url = Bundle.main.resourceURL?.appendingPathComponent("Assets/parts/\(name).svg") {
                if let image = loadSVG(from: url) {
                    rocketParts[name] = image
                }
            }
            // Also try PNG
            if let url = Bundle.main.resourceURL?.appendingPathComponent("Assets/parts/\(name).png") {
                if let image = NSImage(contentsOf: url) {
                    rocketParts[name] = image
                }
            }
        }
    }

    private func loadUIIcons() {
        let iconNames = ["throttle", "pitch", "yaw", "build", "launch", "reset", "time"]

        for name in iconNames {
            if let url = Bundle.main.resourceURL?.appendingPathComponent("Assets/icons/\(name).svg") {
                if let image = loadSVG(from: url) {
                    uiIcons[name] = image
                }
            }
            if let url = Bundle.main.resourceURL?.appendingPathComponent("Assets/icons/\(name).png") {
                if let image = NSImage(contentsOf: url) {
                    uiIcons[name] = image
                }
            }
        }
    }

    /// Get rocket part image by name
    func getRocketPart(_ name: String) -> NSImage? {
        return rocketParts[name]
    }

    /// Get UI icon by name
    func getUIIcon(_ name: String) -> NSImage? {
        return uiIcons[name]
    }
}

// MARK: - SwiftUI Image Extension
extension Image {
    /// Create Image from NSImage
    static func nsImage(_ nsImage: NSImage) -> Image {
        Image(nsImage: nsImage)
    }
}

// MARK: - NSImage Extension for SwiftUI
extension NSImage {
    /// Convert NSImage to SwiftUI Image
    var swiftImage: Image {
        Image(nsImage: self)
    }
}